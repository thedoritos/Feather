//
//  STTwitter+RACSignalSupport.m
//  Feather
//
//  Created by thedoritos on 2/5/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "STTwitterAPI+RACSignalSupport.h"

@implementation STTwitterAPI (RACSignalSupport)

- (RACSignal *)rac_postReverseOAuthTokenRequest
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
            [subscriber sendNext:authenticationHeader];
            [subscriber sendCompleted];
        } errorBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)rac_verifyCredentials
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self verifyCredentialsWithSuccessBlock:^(NSString *username) {
            [subscriber sendNext:username];
            [subscriber sendCompleted];
        } errorBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)rac_postReverseAuthAccessTokenWithAuthenticationHeader:(NSString *)authenticationHeader
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
              successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
                  [subscriber sendNext:[[STAccessToken alloc] initWithOAuthToken:oAuthToken
                                                                OAuthTokenSecret:oAuthTokenSecret
                                                                          userID:userID
                                                                      screenName:screenName]];
                  [subscriber sendCompleted];
              } errorBlock:^(NSError *error) {
                  [subscriber sendError:error];
              }];
        return nil;
    }];
}

@end
