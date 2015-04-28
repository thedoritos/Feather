//
//  FEZTweet.h
//  Fezaar
//
//  Created by t-matsumura on 3/20/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "FEZUser.h"
#import "FEZEntities.h"

@interface FEZTweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *statusID;

@property (copy, nonatomic, readonly) NSDate *creationDate;

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, readonly) FEZUser *user;

@property (nonatomic, copy, readonly) NSNumber *favoriteCount;

@property (nonatomic, copy, readonly) NSNumber *retweetCount;

@property (nonatomic, copy, readonly) FEZEntities *entities;

- (BOOL)containsURL;
- (BOOL)containsMedia;

@end
