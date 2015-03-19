//
//  STAccessToken.m
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "STAccessToken.h"

@implementation STAccessToken

- (instancetype)initWithOAuthToken:(NSString *)oAuthToken
                  OAuthTokenSecret:(NSString *)oAuthTokenSecret
                            userID:(NSString *)userID
                        screenName:(NSString *)screenName
{
    self = [super init];
    if (self) {
        _oAuthToken = oAuthToken;
        _oAuthTokenSecret = oAuthTokenSecret;
        _userID = userID;
        _screenName = screenName;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"STAccessToken oAuthToken:%@, oAuthTokenSecret:%@, userID:%@, screenName:%@",
            self.oAuthToken, self.oAuthTokenSecret, self.userID, self.screenName];
}

@end
