//
//  FEZListViewController.m
//  Fezaar
//
//  Created by t-matsumura on 4/6/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "FEZListViewController.h"
#import "FEZTweetCell.h"
#import "FEZTwitter.h"
#import "FEZAuthViewController.h"
#import "FEZWebViewController.h"
#import "FEZPreference.h"
#import "HUKArray.h"

static NSString * const kTweetCellID = @"FEZTweetCell";

@interface FEZListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@property (nonatomic) FEZList *list;
@property (nonatomic) FEZTimeline *timeline;

@property (nonatomic) FEZTwitter *twitter;

@end

@implementation FEZListViewController

- (instancetype)initWithList:(FEZList *)list
{
    self = [super init];
    if (self) {
        self.list = list;
        
        FEZPreference *preference = [FEZPreference load];
        preference.lastViewedListID = list.listID;
        [preference save];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"List";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleListCollectionView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentAccounts)];
    
    CALayer *baseLayer = self.navigationController.view.layer;
    baseLayer.shadowOpacity = 0.5f;
    baseLayer.shadowRadius = 5.0f;
    baseLayer.shadowColor = [UIColor blackColor].CGColor;
    baseLayer.shadowPath = [UIBezierPath bezierPathWithRect:baseLayer.bounds].CGPath;
    
    self.timeline = [FEZTimeline timeline];
    
    [self.tweetTableView registerNib:[UINib nibWithNibName:kTweetCellID bundle:nil] forCellReuseIdentifier:kTweetCellID];
    
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tweetTableView.estimatedRowHeight = 120;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    @weakify(self)
    [self.tweetTableView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        [[self.twitter fetchListTimeline:self.list laterThanTimeline:self.timeline]
         subscribeNext:^(FEZTimeline *timeline) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self updateTimeline:timeline];
                 [self.tweetTableView.pullToRefreshView stopAnimating];
             });
         } error:^(NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tweetTableView.pullToRefreshView stopAnimating];
             });
             NSLog(@"Failed to fetch list timeline with error: %@", error);
         }];
    }];
    
    [self.tweetTableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [[self.twitter fetchListTimeline:self.list olderThanTimeline:self.timeline]
         subscribeNext:^(FEZTimeline *timeline) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self updateTimeline:timeline];
                 [self.tweetTableView.infiniteScrollingView stopAnimating];
             });
         } error:^(NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tweetTableView.infiniteScrollingView stopAnimating];
                 NSLog(@"Failed to fetch list timeline with error: %@", error);
             });
         }];
    }];

    
    self.twitter = [[FEZTwitter alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveListSelection:) name:@"FEZNotificationShowList" object:nil];
    
    [self refreshTimeline];
}

#pragma mark - UI Actions

- (void)toggleListCollectionView
{
    if (self.slidingViewController.currentTopViewPosition != ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController resetTopViewAnimated:YES];
        return;
    }
    
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)presentAccounts
{
    FEZAuthViewController *authViewController = [[FEZAuthViewController alloc] init];
    UINavigationController *authNavigationController = [[UINavigationController alloc] initWithRootViewController:authViewController];
    
    [self presentViewController:authNavigationController animated:YES completion:nil];
}

#pragma mark - Notifications

- (void)didReceiveListSelection:(NSNotification *)notification
{
    FEZList *selectedList = notification.userInfo[@"list"];
    self.list = selectedList;
    self.title = selectedList.name;
    
    [self refreshTimeline];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeline.length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEZTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    FEZTweet *tweet = [self.timeline tweetAtIndex:indexPath.row];
    
    [cell presentTweet:tweet];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEZTweet *selectedTweet = [self.timeline tweetAtIndex:indexPath.row];
    if (![selectedTweet containsURL]) {
        return;
    }
    
    FEZWebViewController *webViewController = [[FEZWebViewController alloc] initWithURL:selectedTweet.entities.urls.firstObject tweet:selectedTweet];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Private

- (void)refreshTimeline
{
    @weakify(self)
    if (self.list) {
        [[self.twitter
          fetchListTimeline:self.list]
          subscribeNext:^(FEZTimeline *timeline) {
              @strongify(self)
              [self updateTimeline:timeline];
          }];
          return;
    }
    
    [[[self.twitter fetchLists]
       flattenMap:^(FEZListCollection *lists) {
           if (lists.length == 0) {
               return [RACSignal return:[FEZTimeline timeline]];
           }
        
           @strongify(self)
           FEZPreference *preference = [FEZPreference load];
           NSArray *listArray = lists.lists;
           if (preference.lastViewedListID) {
               listArray = [listArray huk_filter:^BOOL(FEZList *list) {
                   return [list.listID isEqualToNumber:preference.lastViewedListID];
               }];
           }
           
           self.list = listArray.firstObject;
           return [self.twitter fetchListTimeline:self.list];
       }]
       subscribeNext:^(FEZTimeline *timeline) {
           @strongify(self)
           [self updateTimeline:timeline];
       }];
}

- (void)updateTimeline:(FEZTimeline *)timeline
{
    self.timeline = timeline;
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.tweetTableView reloadData];
    });
}

@end
