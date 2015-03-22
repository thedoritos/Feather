//
//  FEZAuthViewController.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZAuthViewController.h"
#import "HUKTwitterAccountStore.h"
#import "HUKTwitterAccountStore+RACSupport.h"

@interface FEZAuthViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *accountTableView;

@property (nonatomic) NSArray *accounts;
@property (nonatomic) ACAccount *currentAccount;

@property (nonatomic) HUKTwitterAccountStore *accountStore;

@end

@implementation FEZAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Authorize";
    
    self.accountTableView.dataSource = self;
    self.accountTableView.delegate = self;
    
    self.accounts = @[];
    
    self.accountStore = [[HUKTwitterAccountStore alloc] init];
    
    [self refreshAccounts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAccounts)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Accounts";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    ACAccount *account = self.accounts[indexPath.row];
    BOOL isCurrentAccount = self.currentAccount != nil && [self.currentAccount.username isEqualToString:account.username];
    
    cell.textLabel.text = [NSString stringWithFormat:@"@%@", account.username];
    cell.accessoryType = isCurrentAccount ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ACAccount *account = self.accounts[indexPath.row];
    [self authorizeAccount:account];
}

#pragma mark - Private

- (void)refreshAccounts
{
    @weakify(self)
    [[[[[[self.accountStore rac_requestAccounts]
      doNext:^(NSArray *accounts) {
          @strongify(self)
          self.accounts = accounts;
      }]
      then:^{
          @strongify(self)
          return [self.accountStore rac_requestCurrentAccount];
      }] doNext:^(ACAccount *account) {
          @strongify(self)
          self.currentAccount = account;
      }] finally:^{
          @strongify(self)
          [self refreshAccountTable];
      }] subscribeError:^(NSError *error) {
          NSLog(@"Failed to list accounts with error: %@", error);
      }];
}

- (void)refreshAccountTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accountTableView reloadData];
    });
}

- (void)authorizeAccount:(ACAccount *)account
{
    @weakify(self)
    [[self.accountStore rac_registerCurrentAccount:account] subscribeNext:^(ACAccount *account) {
        @strongify(self)
        self.currentAccount = account;
        [self refreshAccountTable];
    } error:^(NSError *error) {
        NSLog(@"Failed to authorize accounts with error: %@", error);
    }];
}

@end
