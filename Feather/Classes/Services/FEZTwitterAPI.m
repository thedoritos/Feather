//
//  FEZTwitterAPI.m
//  Feather
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZTwitterAPI.h"
#import "FEZConfig.h"

@interface FEZTwitterAPI ()

@property (nonatomic) STTwitterAPI *twitterAPI;

@property (nonatomic) FEZConfig *config;

@end

@implementation FEZTwitterAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.config = [FEZConfig defaultConfig];
    }
    return self;
}

- (RACSignal *)authorize
{
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:self.config.consumerKey
                                                             consumerSecret:self.config.consumerSecret];
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
                   self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:self.config.consumerKey
                                                                   consumerSecret:self.config.consumerSecret
                                                                       oauthToken:accessToken.oAuthToken
                                                                 oauthTokenSecret:accessToken.oAuthTokenSecret];
    }];
}

@end
