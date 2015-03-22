//
//  HUKTwitterError.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const HUKTwitterErrorDomain = @"HUKTwitterErrorDomain";

static NSString * const HUKTwitterUserInfoInnerError = @"HUKTwitterUserInfoInnerError";

typedef NS_ENUM(NSUInteger, HUKTwitterErrorCode)
{
    HUKTwitterErrorCodeUndefined,
    
    HUKTwitterErrorCodeAccountStoreAccessDenied,
    HUKTwitterErrorCodeAccountStoreAccountNotFound,
    HUKTwitterErrorCodeAccountStoreCurrentAccountNotFound,
    
    HUKTwitterErrorCodeRequestFailed,
    HUKTwitterErrorCodeRequestRateLimitExceeded,
    HUKTwitterErrorCodeRequestBadStatusReceived,
    HUKTwitterErrorCodeRequestBadDataReceived,
};

@interface HUKTwitterError : NSError

+ (instancetype)errorWithCode:(HUKTwitterErrorCode)code;
+ (instancetype)errorWithCode:(HUKTwitterErrorCode)code innerError:(NSError *)error;

+ (instancetype)errorWithURLResponse:(NSHTTPURLResponse *)urlResponse;

@end
