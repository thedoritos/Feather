//
//  HUKTwitter.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitter.h"
#import "HUKArray.h"
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
        
        self.account = accounts.lastObject;
        
        if (accountHandler) {
            accountHandler(self.account);
        }
    }];
}

- (void)getStatusesHomeTimelineSuccess:(JsonArrayHandler)jsonArrayHandler failure:(ErrorHandler)errorHandler
{
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                                             params:@{}];
    
    [request huk_performRequestWithHandler:jsonArrayHandler failure:errorHandler];
}

- (void)getListsOwnerships:(JsonDictionaryHandler)jsonDictionaryHandler failure:(ErrorHandler)errorHandler
{
    SLRequest *request = [self requestWithURLString:@"https://api.twitter.com/1.1/lists/ownerships.json"
                                             params:@{}];
    
    [request huk_performRequestWithHandler:jsonDictionaryHandler failure:errorHandler];
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
