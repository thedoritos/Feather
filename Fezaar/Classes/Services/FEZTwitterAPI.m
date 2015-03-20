//
//  FEZTwitterAPI.m
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>
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

- (RACSignal *)confirmAuthorized
{
    if (self.twitterAPI != nil
        && self.twitterAPI.oauthAccessToken != nil
        && self.twitterAPI.oauthAccessTokenSecret != nil)
    {
        return [RACSignal empty];
    }
    
    return [self authorize];
}

- (RACSignal *)fetchHomeTimeline
{
    @weakify(self)
    return [[[self confirmAuthorized]
            then:^{
                @strongify(self)
                return [self.twitterAPI fez_getStatusesHomeTimeline];
            }] map:^(NSArray *tweetJsonArray) {
                return [FEZTimeline timelineFromTweetJsonArray:tweetJsonArray];
            }];
}

- (RACSignal *)fetchHomeTimelineBackground
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        
        return nil;
    }];
}

@end
