//
//  FEZListCollectionViewController.m
//  Fezaar
//
//  Created by t-matsumura on 3/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZListCollectionViewController.h"
#import "FEZTwitter.h"

@interface FEZListCollectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic) NSArray *listCollection;
@property (nonatomic) FEZTwitter *twitter;

@end

@implementation FEZListCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listCollection = @[];
    self.twitter = [[FEZTwitter alloc] init];
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self refreshListCollection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *list = self.listCollection[indexPath.row];
    
    cell.textLabel.text = @"name";
    cell.detailTextLabel.text = @"detail";
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Private

- (void)refreshListCollection
{
    @weakify(self)
    [[self.twitter fetchLists]
     subscribeNext:^(NSArray *lists) {
         @strongify(self)
         [self updateListCollection:lists];
     } error:^(NSError *error) {
         NSLog(@"Failed to fetch lists with error: %@", error);
     }];
}

- (void)updateListCollection:(NSArray *)listCollection
{
    self.listCollection = listCollection;
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.listTableView reloadData];
    });
}

@end
