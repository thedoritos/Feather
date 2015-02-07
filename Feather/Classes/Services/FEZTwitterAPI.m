//
//  FEZTwitterAPI.m
//  Feather
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZTwitterAPI.h"

#define FEZConsumerKey    @"xofNjodzkYyfCbd1EfT8YEBXB"
#define FEZConsumerSecret @"7rCfqvORZVJgQ1mws8sPMrQs6d2h2K9I8Fmu6qarWfb9MUSZdK"

@interface FEZTwitterAPI ()

@property (nonatomic) STTwitterAPI *twitterAPI;

@end

@implementation FEZTwitterAPI

- (RACSignal *)authorize
{
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:FEZConsumerKey consumerSecret:FEZConsumerSecret];
    STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    __block NSString *authenticationHeader;
    
    @weakify(self)
    return [[[[twitterAPI
               rac_postReverseOAuthTokenRequest]
               flattenMap:^(NSString *header) {
                   authenticationHeader = header;
                   return [twitterAPIOS rac_verifyCredentials];
               }]
               flattenMap:^(NSString *username) {
                   return [twitterAPIOS rac_postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader];
               }]
               doNext:^(STAccessToken *accessToken) {
                   @strongify(self)
                   self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:FEZConsumerKey
                                                                   consumerSecret:FEZConsumerSecret
                                                                       oauthToken:accessToken.oAuthToken
                                                                 oauthTokenSecret:accessToken.oAuthTokenSecret];
    }];
}

@end
