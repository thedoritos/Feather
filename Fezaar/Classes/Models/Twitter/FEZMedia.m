//
//  FEZMedia.m
//  Fezaar
//
//  Created by t-matsumura on 4/28/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZMedia.h"

@implementation FEZMedia

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"mediaID" : @"id",
        @"mediaURL" : @"media_url"
    };
}

+ (NSValueTransformer *)mediaURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (UIImage *)image
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:self.mediaURL]];
}

@end
