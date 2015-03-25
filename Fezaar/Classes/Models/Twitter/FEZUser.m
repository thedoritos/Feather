//
//  FEZUser.m
//  Fezaar
//
//  Created by t-matsumura on 3/23/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZUser.h"

@implementation FEZUser

- (NSURL *)profileImageURLWithType:(FEZUserProfileImageType)type
{
    NSString *urlString = self.profileImageURL.absoluteString;
    switch (type) {
        case FEZUserProfileImageTypeNormal:
        default:
            return [NSURL URLWithString:urlString];
        case FEZUserProfileImageTypeBigger:
            return [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
        case FEZUserProfileImageTypeMini:
            return [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"normal" withString:@"mini"]];
        case FEZUserProfileImageTypeOriginal:
            return [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"normal" withString:@""]];
    }
}

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
