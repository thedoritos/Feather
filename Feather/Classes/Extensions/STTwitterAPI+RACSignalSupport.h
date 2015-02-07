//
//  STTwitterAPI+RACSignalSupport.h
//  Feather
//
//  Created by thedoritos on 2/5/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <STTwitterAPI.h>
#import <ReactiveCocoa.h>

#import "STAccessToken.h"

@interface STTwitterAPI (RACSignalSupport)

- (RACSignal *)rac_postReverseOAuthTokenRequest;

- (RACSignal *)rac_verifyCredentials;

- (RACSignal *)rac_postReverseAuthAccessTokenWithAuthenticationHeader:(NSString *)authenticationHeader;

@end
