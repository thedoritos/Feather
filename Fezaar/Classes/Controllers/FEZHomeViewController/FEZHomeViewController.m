//
//  FEZHomeViewController.m
//  Fezaar
//
//  Created by t-matsumura on 3/22/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZHomeViewController.h"
#import "FEZTweetCell.h"
#import "FEZTwitter.h"
#import "FEZAuthViewController.h"
#import "FEZColor.h"

#import <SVPullToRefresh/SVPullToRefresh.h>

static NSString * const kTweetCellID = @"FEZTweetCell";

@interface FEZHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@property (nonatomic) FEZTimeline *homeTimeline;

@property (nonatomic) FEZTwitter *twitter;

@end

@implementation FEZHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
        
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentAccounts)];
    self.navigationItem.rightBarButtonItem = accountButton;
    
    self.homeTimeline = [FEZTimeline timeline];
    
    [self.tweetTableView registerNib:[UINib nibWithNibName:kTweetCellID bundle:nil] forCellReuseIdentifier:kTweetCellID];
    
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tweetTableView.estimatedRowHeight = 120;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    @weakify(self)
    [self.tweetTableView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        [[self.twitter fetchHomeTimelineLaterThanTimeline:self.homeTimeline]
         subscribeNext:^(FEZTimeline *timeline) {
             [self.tweetTableView.pullToRefreshView stopAnimating];
             [self updateHomeTimeline:timeline];
         } error:^(NSError *error) {
             [self.tweetTableView.pullToRefreshView stopAnimating];
             NSLog(@"Failed to fetch home timeline with error: %@", error);
         }];
    }];
    
    [self.tweetTableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [[self.twitter fetchHomeTimelineOlderThanTimeline:self.homeTimeline]
         subscribeNext:^(FEZTimeline *timeline) {
             [self.tweetTableView.pullToRefreshView stopAnimating];
             [self updateHomeTimeline:timeline];
         } error:^(NSError *error) {
             [self.tweetTableView.pullToRefreshView stopAnimating];
             NSLog(@"Failed to fetch home timeline with error: %@", error);
         }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.twitter = [[FEZTwitter alloc] init];
    [self refreshHomeTimeline];
}

#pragma mark - UI Action

- (void)presentAccounts
{
    FEZAuthViewController *authViewController = [[FEZAuthViewController alloc] init];
    UINavigationController *authNavigationController = [[UINavigationController alloc] initWithRootViewController:authViewController];
    
    [self presentViewController:authNavigationController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.homeTimeline.length == 0) {
        UILabel *emptyMessageLabel = [[UILabel alloc] initWithFrame:self.view.frame];
        
        emptyMessageLabel.text = @"timeline is empty";
        emptyMessageLabel.textColor = [UIColor whiteColor];
        emptyMessageLabel.numberOfLines = 0;
        emptyMessageLabel.textAlignment = NSTextAlignmentCenter;
        emptyMessageLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:14];
        [emptyMessageLabel sizeToFit];
        
        self.tweetTableView.backgroundView = emptyMessageLabel;
        self.tweetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }
    
    self.tweetTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeTimeline.length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEZTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    FEZTweet *tweet = [self.homeTimeline tweetAtIndex:indexPath.row];
    
    [cell presentTweet:tweet];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Private

- (void)refreshHomeTimeline
{
    @weakify(self)
    [[self.twitter fetchHomeTimelineLaterThanTimeline:self.homeTimeline]
     subscribeNext:^(FEZTimeline *timeline) {
         @strongify(self)
         [self updateHomeTimeline:timeline];
     } error:^(NSError *error) {
         NSLog(@"Failed to fetch home timeline with error: %@", error);
     }];
}

- (void)updateHomeTimeline:(FEZTimeline *)timeline
{
    self.homeTimeline = timeline;
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.tweetTableView reloadData];
    });
}

@end
