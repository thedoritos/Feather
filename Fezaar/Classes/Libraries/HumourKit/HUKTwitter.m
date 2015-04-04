//
//  HUKTwitter.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitter.h"
#import "HUKArray.h"
#import "HUKTwitterAccountStore+RACSupport.h"
#import "SLRequest+HUKTwitter.h"

@interface HUKTwitter ()

@property (nonatomic) ACAccount *account;

@end

@implementation HUKTwitter

- (BOOL)authorized
{
    return self.account != nil;
}

- (void)authorizeSuccess:(AccountHandler)accountHandler failure:(ErrorHandler)errorHandler
{
    HUKTwitterAccountStore *accountStore = [[HUKTwitterAccountStore alloc] init];
    [[accountStore rac_requestCurrentAccount] subscribeNext:^(ACAccount *account) {
        self.account = account;
        if (accountHandler) {
            accountHandler(account);
        }
    } error:^(NSError *error) {
        self.account = nil;
        if (errorHandler) {
            errorHandler(error);
        }
    }];
}

- (void)getStatusesHomeTimelineSuccess:(JsonArrayHandler)jsonArrayHandler failure:(ErrorHandler)errorHandler
{
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                                             params:@{}];
    
    [request huk_performRequestWithHandler:jsonArrayHandler failure:errorHandler];
}

- (void)getStatusesHomeTimelineWithSinceID:(NSNumber *)sinceID
                                     maxID:(NSNumber *)maxID
                                   success:(JsonArrayHandler)jsonArrayHandler
                                   failure:(ErrorHandler)errorHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (sinceID) {
        params[@"since_id"] = [sinceID stringValue];
    }
    if (maxID) {
        params[@"max_id"] = [maxID stringValue];
    }
    
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                                             params:params];
    
    [request huk_performRequestWithHandler:jsonArrayHandler failure:errorHandler];
}

- (void)getListsOwnerships:(JsonDictionaryHandler)jsonDictionaryHandler failure:(ErrorHandler)errorHandler
{
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/lists/ownerships.json"
                                             params:@{}];
    
    [request huk_performRequestWithHandler:jsonDictionaryHandler failure:errorHandler];
}

- (void)getListsStatuses:(NSNumber *)listID
                 success:(JsonArrayHandler)jsonArrayHandler
                 failure:(ErrorHandler)errorHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (listID) {
        params[@"list_id"] = [listID stringValue];
    }
    
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/lists/statuses.json"
                                             params:params];
    
    [request huk_performRequestWithHandler:jsonArrayHandler failure:errorHandler];
}

- (SLRequest *)requestWithURLString:(NSString *)urlString params:(NSDictionary *)params
{
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:urlString]
                                               parameters:params];
    
    request.account = self.account;
    
    return request;
}

@end
