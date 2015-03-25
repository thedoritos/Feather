//
//  SLRequest+HUKTwitter.h
//  Fezaar
//
//  Created by t-matsumura on 3/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "HUKTwitter.h"

@interface SLRequest (HUKTwitter)

- (void)huk_performRequestWithHandler:(void(^)(id json))jsonHandler
                              failure:(ErrorHandler)errorHandler;

@end
