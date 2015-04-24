//
//  FEZTweet.m
//  Fezaar
//
//  Created by t-matsumura on 3/20/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZTweet.h"

@implementation FEZTweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"statusID" : @"id",
        @"creationDate" : @"created_at",
        @"favoriteCount" : @"favorite_count",
        @"retweetCount" : @"retweet_count"
    };
}

+ (NSValueTransformer *)creationDateJSONTransformer {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss Z yyyy"];
    });
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        if ([value isKindOfClass:NSString.class]) {
            return [dateFormatter dateFromString:value];
        }
        return nil;
    } reverseBlock:^id(NSDate *date) {
        if ([date isKindOfClass:NSDate.class]) {
            return [dateFormatter stringFromDate:date];
        }
        return nil;
    }];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:FEZUser.class];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"FEZTweet statusID:%@, text:%@", self.statusID, self.text];
}

@end
