//
//  STAccessToken.h
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAccessToken : NSObject

@property (nonatomic, copy, readonly) NSString *oAuthToken;
@property (nonatomic, copy, readonly) NSString *oAuthTokenSecret;
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *screenName;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithOAuthToken:(NSString *)oAuthToken
                  OAuthTokenSecret:(NSString *)oAuthTokenSecret
                            userID:(NSString *)userID
                        screenName:(NSString *)screenName;

@end
