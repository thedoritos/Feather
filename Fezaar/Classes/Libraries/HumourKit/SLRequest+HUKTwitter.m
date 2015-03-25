//
//  SLRequest+HUKTwitter.m
//  Fezaar
//
//  Created by t-matsumura on 3/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "SLRequest+HUKTwitter.h"

@implementation SLRequest (HUKTwitter)

- (void)huk_performRequestWithHandler:(JsonObjectHandler)jsonObjectHandler
                              failure:(ErrorHandler)errorHandler
{
    [self performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeRequestFailed]);
            }
            return;
        }
        
        if (!(200 <= urlResponse.statusCode && urlResponse.statusCode < 300)) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithURLResponse:urlResponse]);
            }
            return;
        }
        
        NSError *parseError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError) {
            if (errorHandler) {
                errorHandler([HUKTwitterError errorWithCode:HUKTwitterErrorCodeRequestBadDataReceived]);
            }
            return;
        }
        
        if (jsonObjectHandler) {
            jsonObjectHandler(jsonObject);
        }
    }];
}

@end
