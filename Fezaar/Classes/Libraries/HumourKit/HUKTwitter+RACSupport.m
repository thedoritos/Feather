//
//  HUKTwitter+RACSupport.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitter+RACSupport.h"

@implementation HUKTwitter (RACSupport)

- (RACSignal *)rac_authorize
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self authorizeSuccess:^(ACAccount *account) {
            [subscriber sendNext:account];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_getStatusesHomeTimeline
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self getStatusesHomeTimelineSuccess:^(NSArray *jsonArray) {
            [subscriber sendNext:jsonArray];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_getStatusesHomeTimelineWithSinceID:(NSNumber *)sinceID
                                                maxID:(NSNumber *)maxID
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self getStatusesHomeTimelineWithSinceID:sinceID
                                           maxID:maxID
                                         success:^(NSArray *jsonArray) {
                                             [subscriber sendNext:jsonArray];
                                             [subscriber sendCompleted];
                                         } failure:^(NSError *error) {
                                             [subscriber sendError:error];
                                         }];
        
        return nil;
    }];
}

- (RACSignal *)rac_getListsOwnerships
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self getListsOwnerships:^(NSDictionary *jsonDictionary) {
            [subscriber sendNext:jsonDictionary];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

@end
