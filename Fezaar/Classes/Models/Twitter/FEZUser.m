//
//  FEZUser.m
//  Fezaar
//
//  Created by t-matsumura on 3/23/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZUser.h"

@implementation FEZUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"userID" : @"id",
        @"screenName" : @"screen_name",
        @"profileImageURL": @"profile_image_url"
    };
}

+ (NSValueTransformer *)profileImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
