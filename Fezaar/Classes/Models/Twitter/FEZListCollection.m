//
//  FEZListCollection.m
//  Fezaar
//
//  Created by t-matsumura on 3/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZListCollection.h"

@implementation FEZListCollection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _previousCursor = nil;
        _nextCursor = nil;
        _lists = @[];
    }
    return self;
}

+ (instancetype)collection
{
    return [[FEZListCollection alloc] init];
}

+ (instancetype)collectionFromJsonDictionary:(NSDictionary *)jsonDictionary
{
    NSError *error;
    FEZListCollection *collection = [MTLJSONAdapter modelOfClass:[FEZListCollection class] fromJSONDictionary:jsonDictionary error:&error];
    
    if (error) {
        NSLog(@"Error: failed to parse json:%@ with error:%@", jsonDictionary, error);
        return [FEZListCollection collection];
    }
    
    return collection;
}

- (NSUInteger)length
{
    return self.lists.count;
}

- (FEZList *)listAtIndex:(NSUInteger)index
{
    return self.lists[index];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"previousCursor" : @"previous_cursor",
        @"nextCursor" : @"next_cursor"
    };
}

+ (NSValueTransformer *)listsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FEZList class]];
}


@end
