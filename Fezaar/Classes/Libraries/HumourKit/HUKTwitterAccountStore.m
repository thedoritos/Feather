//
//  HUKTwitterAccountStore.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitterAccountStore.h"
#import "HUKArray.h"

static NSString * const kUserDefaultsCurrentAccountUsernameKey = @"HUKTwitterAccountStoreCurrentAccountUsernameKey";

@implementation HUKTwitterAccountStore

- (void)requestAccounts:(void(^)(NSArray *accounts))accountsHandler
                failure:(void(^)(NSError *error))errorHandler
{
    [self setupAccountStore:^(ACAccountStore *accountStore, NSArray *accounts) {
        if (accountsHandler) {
            accountsHandler(accounts);
        }
    } failure:errorHandler];
}

- (void)requestCurrentAccount:(void(^)(ACAccount *account))accountHandler
                      failure:(void(^)(NSError *error))errorHandler
{
    [self setupAccountStore:^(ACAccountStore *accountStore, NSArray *accounts) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currentAccountUsername = [userDefaults objectForKey:kUserDefaultsCurrentAccountUsernameKey];
        if (!currentAccountUsername) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeAccountStoreCurrentAccountNotFound]);
            }
            return;
        }
        
        ACAccount *currentAccountInStore = [accounts huk_match:^BOOL(ACAccount *account) {
            return [account.username isEqualToString:currentAccountUsername];
        }];
        if (!currentAccountInStore) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeAccountStoreCurrentAccountNotFound]);
            }
            return;
        }
        
        if (accountHandler) {
            accountHandler(currentAccountInStore);
        }
        
    } failure:errorHandler];
}

- (void)registerCurrentAccount:(ACAccount *)currentAccount
                       success:(void(^)(ACAccount *account))accountHandler
                       failure:(void(^)(NSError *error))errorHandler
{
    [self setupAccountStore:^(ACAccountStore *accountStore, NSArray *accounts) {
        
        ACAccount *currentAccountInStore = [accounts huk_match:^BOOL(ACAccount *account) {
            return [account.username isEqualToString:currentAccount.username];
        }];
        if (!currentAccountInStore) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeAccountStoreCurrentAccountNotFound]);
            }
            return;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:currentAccountInStore.username forKey:kUserDefaultsCurrentAccountUsernameKey];
        [userDefaults synchronize];
        
        if (accountHandler) {
            accountHandler(currentAccountInStore);
        }
        
    } failure:errorHandler];
}

- (void)setupAccountStore:(void(^)(ACAccountStore *accountStore, NSArray *accounts))accountStoreHandler
                  failure:(void(^)(NSError *error))errorHandler
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType  *accountType  = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (error) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeAccountStoreAccessDenied]);
            }
            return;
        }
        
        NSArray *accounts = [accountStore accountsWithAccountType:accountType];
        if ([accounts huk_isEmpty]) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeAccountStoreAccountNotFound]);
            }
            return;
        }
        
        if (accountStoreHandler) {
            accountStoreHandler(accountStore, accounts);
        }
    }];
}

@end
