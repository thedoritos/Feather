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

@property (nonatomic) FEZListCollection *listCollection;
@property (nonatomic) FEZTwitter *twitter;

@end

@implementation FEZListCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Lists";
    
    self.listCollection = [FEZListCollection collection];
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
    return self.listCollection.length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    FEZList *list = [self.listCollection listAtIndex:indexPath.row];
    
    cell.textLabel.text = list.name;
    cell.detailTextLabel.text = list.listDescription;
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Private

- (void)refreshListCollection
{
    @weakify(self)
    [[self.twitter fetchLists]
     subscribeNext:^(FEZListCollection *listCollection) {
         @strongify(self)
         [self updateListCollection:listCollection];
     } error:^(NSError *error) {
         NSLog(@"Failed to fetch lists with error: %@", error);
     }];
}

- (void)updateListCollection:(FEZListCollection *)listCollection
{
    self.listCollection = listCollection;
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.listTableView reloadData];
    });
}

@end
