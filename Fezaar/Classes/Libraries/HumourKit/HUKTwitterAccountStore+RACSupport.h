//
//  HUKTwitterAccountStore+RACSupport.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HUKTwitterAccountStore.h"

@interface HUKTwitterAccountStore (RACSupport)

- (RACSignal *)rac_requestAccounts;

- (RACSignal *)rac_requestCurrentAccount;

- (RACSignal *)rac_registerCurrentAccount:(ACAccount *)account;

@end
