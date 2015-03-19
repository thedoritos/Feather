//
//  STTwitterAPI+RACSignalSupport.h
//  Fezaar
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

- (RACSignal *)rac_getStatusesHomeTimelineWithCount:(NSString *)count
                                            sinceID:(NSString *)sinceID
                                              maxID:(NSString *)maxID
                                           trimUser:(NSNumber *)trimUser
                                     excludeReplies:(NSNumber *)excludeReplies
                                 contributorDetails:(NSNumber *)contributorDetails
                                    includeEntities:(NSNumber *)includeEntities;

@end
