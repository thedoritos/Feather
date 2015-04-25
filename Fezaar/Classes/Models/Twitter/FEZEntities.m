//
//  FEZEntities.m
//  Fezaar
//
//  Created by t-matsumura on 4/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZEntities.h"
#import "HUKArray.h"

@implementation FEZEntities

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
    };
}

+ (NSValueTransformer *)urlsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^NSArray *(NSArray *urls) {
        return [urls huk_map:^NSURL *(NSDictionary *url) {
            return [NSURL URLWithString:url[@"expanded_url"]];
        }];
    }];
}

- (BOOL)containsURL
{
    return self.urls.count > 0;
}

@end
