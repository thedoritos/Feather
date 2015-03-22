//
//  FEZTweet.h
//  Fezaar
//
//  Created by t-matsumura on 3/20/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "FEZUser.h"

@interface FEZTweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *statusID;

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, readonly) FEZUser *user;

@end
