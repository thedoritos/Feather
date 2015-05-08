//
//  FEZListViewController.m
//  Fezaar
//
//  Created by t-matsumura on 4/6/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "FEZListViewController.h"
#import "FEZTweetCell.h"
#import "FEZImageCell.h"
#import "FEZTwitter.h"
#import "FEZAuthViewController.h"
#import "FEZWebViewController.h"
#import "FEZPreference.h"
#import "HUKArray.h"
#import "UITableView+StrongScroll.h"

static NSString * const kTweetCellID = @"FEZTweetCell";
static NSString * const kImageCellID = @"FEZImageCell";

static NSString * const kImageImage   = @"ic_image_black_.png";
static NSString * const kMenuImage    = @"ic_menu_black_.png";
static NSString * const kAccountImage = @"ic_person_black_.png";
static NSString * const kURLImage     = @"ic_public_black_.png";

@interface FEZListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@property (nonatomic) FEZList *list;
@property (nonatomic) FEZTimeline *timeline;

@property (nonatomic) FEZTwitter *twitter;

@property (nonatomic) BOOL filteringImages;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kMenuImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleListCollectionView)];
    
    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kImageImage] style:UIBarButtonItemStylePlain target:self action:@selector(filterImages)];
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kAccountImage] style:UIBarButtonItemStylePlain target:self action:@selector(presentAccounts)];
    
    self.navigationItem.rightBarButtonItems = @[accountButton, imageButton];
    
    self.filteringImages = NO;
    
    CALayer *baseLayer = self.navigationController.view.layer;
    baseLayer.shadowOpacity = 0.5f;
    baseLayer.shadowRadius = 5.0f;
    baseLayer.shadowColor = [UIColor blackColor].CGColor;
    baseLayer.shadowPath = [UIBezierPath bezierPathWithRect:baseLayer.bounds].CGPath;
    
    self.timeline = [FEZTimeline timeline];
    
    [self.tweetTableView registerNib:[UINib nibWithNibName:kTweetCellID bundle:nil] forCellReuseIdentifier:kTweetCellID];
    [self.tweetTableView registerNib:[UINib nibWithNibName:kImageCellID bundle:nil] forCellReuseIdentifier:kImageCellID];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMediaSelection:) name:@"FEZNotificationShowMedia" object:nil];
    
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

- (void)filterImages
{
    self.filteringImages = !self.filteringImages;
    
    if (self.filteringImages) {
        self.tweetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.view.backgroundColor = [UIColor blackColor];
        self.tweetTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    } else {
        self.tweetTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.view.backgroundColor = [UIColor whiteColor];
        self.tweetTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    [self.tweetTableView reloadData];
}

#pragma mark - Notifications

- (void)didReceiveListSelection:(NSNotification *)notification
{
    FEZList *selectedList = notification.userInfo[@"list"];
    self.list = selectedList;
    self.title = selectedList.name;
    
    FEZPreference *preference = [FEZPreference load];
    preference.lastViewedListID = self.list.listID;
    [preference save];
    
    [self refreshTimeline];
}

- (void)didReceiveMediaSelection:(NSNotification *)notification
{
    FEZTweet *selectedTweet = notification.userInfo[@"tweet"];
    if (![selectedTweet containsMedia]) {
        return;
    }
    
    NSArray *media = selectedTweet.entities.media;
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:media];
    [self presentViewController:photosViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tweets = !self.filteringImages ? self.timeline.tweets : [self.timeline.tweets huk_filter:^BOOL(FEZTweet *tweet) {
        return [tweet containsMedia];
    }];
    
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *tweets = !self.filteringImages ? self.timeline.tweets : [self.timeline.tweets huk_filter:^BOOL(FEZTweet *tweet) {
        return [tweet containsMedia];
    }];
    
    FEZTweet *tweet = tweets[indexPath.row];
    
    if (self.filteringImages) {
        FEZImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellID];
        [cell setTweet:tweet];
        return cell;
    } else {
        FEZTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
        [cell presentTweet:tweet];
        return cell;
    }
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
