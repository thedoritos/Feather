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
    
    self.homeTimeline = [FEZTimeline timeline];
    self.twitter = [[FEZTwitter alloc] init];
    
    [self.tweetTableView registerNib:[UINib nibWithNibName:kTweetCellID bundle:nil] forCellReuseIdentifier:kTweetCellID];
    
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self refreshHomeTimeline];
}

#pragma mark - UITableViewDataSource

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
    [[self.twitter fetchHomeTimeline]
     subscribeNext:^(FEZTimeline *timeline) {
         @strongify(self)
         [self updateHomeTimeline:timeline];
         NSLog(@"Fetched home timeline: %@", timeline);
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
