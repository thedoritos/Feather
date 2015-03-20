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

@end
