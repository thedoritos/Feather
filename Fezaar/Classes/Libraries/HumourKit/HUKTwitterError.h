//
//  HUKTwitterError.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const HUKTwitterErrorDomain = @"HUKTwitterErrorDomain";

typedef NS_ENUM(NSUInteger, HUKTwitterErrorCode)
{
    HUKTwitterErrorCodeUndefined,
    
    HUKTwitterErrorCodeAccountStoreAccessDenied,
    HUKTwitterErrorCodeAccountStoreAccountNotFound,
    
    HUKTwitterErrorCodeRequestFailed,
    HUKTwitterErrorCodeRequestBadStatusReceived,
    HUKTwitterErrorCodeRequestBadDataReceived,
};

@interface HUKTwitterError : NSError

+ (instancetype)errorWithCode:(HUKTwitterErrorCode)code;

@end
