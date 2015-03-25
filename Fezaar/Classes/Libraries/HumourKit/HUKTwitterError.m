//
//  HUKTwitterError.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitterError.h"

@implementation HUKTwitterError

+ (instancetype)errorWithCode:(HUKTwitterErrorCode)code
{
    return [HUKTwitterError errorWithDomain:HUKTwitterErrorDomain code:code userInfo:nil];
}

+ (instancetype)errorWithCode:(HUKTwitterErrorCode)code innerError:(NSError *)error
{
    return [HUKTwitterError errorWithDomain:HUKTwitterErrorDomain code:code userInfo:@{
        HUKTwitterUserInfoInnerError : error
    }];
}

+ (instancetype)errorWithURLResponse:(NSHTTPURLResponse *)urlResponse
{
    NSDictionary *headers = urlResponse.allHeaderFields;
    NSString *rateLimitRemaining = headers[@"x-rate-limit-remaining"];
    if (rateLimitRemaining && [rateLimitRemaining isEqualToString:@"0"]) {
        return [HUKTwitterError errorWithCode:HUKTwitterErrorCodeRequestRateLimitExceeded];
    }
    
    if (!(200 <= urlResponse.statusCode && urlResponse.statusCode < 300)) {
        return [HUKTwitterError errorWithCode:HUKTwitterErrorCodeRequestBadStatusReceived];
    }
    
    return [HUKTwitterError errorWithCode:HUKTwitterErrorCodeRequestFailed];
}

@end
