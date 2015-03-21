//
//  HUKTwitterAccountStore+RACSupport.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitterAccountStore+RACSupport.h"

@implementation HUKTwitterAccountStore (RACSupport)

- (RACSignal *)rac_requestAccounts
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self requestAccounts:^(NSArray *accounts) {
            [subscriber sendNext:accounts];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_requestCurrentAccount
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self requestCurrentAccount:^(ACAccount *account) {
            [subscriber sendNext:account];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_registerCurrentAccount:(ACAccount *)account
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self registerCurrentAccount:account success:^(ACAccount *registered) {
            [subscriber sendNext:registered];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];

        return nil;
    }];
}

@end
