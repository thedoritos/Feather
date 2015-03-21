//
//  HUKTwitterAccountStore.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Accounts/Accounts.h>
#import "HUKTwitterError.h"

@interface HUKTwitterAccountStore : NSObject

- (void)requestAccounts:(void(^)(NSArray *accounts))accountsHandler
                failure:(void(^)(NSError *error))errorHandler;

- (void)requestCurrentAccount:(void(^)(ACAccount *account))accountHandler
                      failure:(void(^)(NSError *error))errorHandler;

- (void)registerCurrentAccount:(ACAccount *)account
                       success:(void(^)(ACAccount *account))accountHandler
                       failure:(void(^)(NSError *error))errorHandler;

@end
