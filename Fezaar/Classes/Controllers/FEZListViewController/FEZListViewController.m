//
//  FEZListViewController.m
//  Fezaar
//
//  Created by t-matsumura on 4/6/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import "FEZListViewController.h"
#import "FEZTweetCell.h"
#import "FEZTwitter.h"
#import "FEZAuthViewController.h"

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"List";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleListCollectionView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentAccounts)];
    
    self.timeline = [FEZTimeline timeline];
    
    [self.tweetTableView registerNib:[UINib nibWithNibName:kTweetCellID bundle:nil] forCellReuseIdentifier:kTweetCellID];
    
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

#pragma mark - Private

- (void)refreshTimeline
{
    if (!self.list) {
        [self updateTimeline:[FEZTimeline timeline]];
        return;
    }
    
    @weakify(self)
    [[self.twitter fetchListTimeline:self.list]
     subscribeNext:^(FEZTimeline *timeline) {
         @strongify(self)
         [self updateTimeline:timeline];
     } error:^(NSError *error) {
         NSLog(@"Failed to fetch list timeline with error: %@", error);
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
