//
//  HUKArray.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>
#import "HUKArray.h"

@implementation HUKArray

@end

@implementation NSArray (HUKArray)

- (BOOL)huk_isEmpty
{
    return self.count == 0;
}

- (BOOL)huk_any:(Predicate)predicate
{
    return [self bk_any:predicate];
}

- (BOOL)huk_none:(Predicate)predicate
{
    return [self bk_none:predicate];
}

- (id)huk_match:(Predicate)predicate
{
    return [self bk_match:predicate];
}

- (id)huk_sample
{
    return [self huk_isEmpty] ? nil : self[arc4random_uniform((int) self.count - 1)];
}

- (instancetype)huk_filter:(Predicate)predicate
{
    return [self bk_select:predicate];
}

- (instancetype)huk_unique:(NSArray *)comparison comparator:(Comparator)comparator
{
    NSMutableArray *unique = [NSMutableArray array];
    
    [unique addObjectsFromArray:[self bk_select:^BOOL(id existing){
        return [comparison bk_none:^BOOL(id incoming) {
            return comparator(existing, incoming) == NSOrderedSame;
        }];
    }]];
    
    [unique addObjectsFromArray:comparison];
    
    return unique;
}

- (instancetype)huk_range:(NSInteger)from to:(NSInteger)to
{
    NSMutableArray *range = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.count; i++) {
        if (from <= i && i <= to) {
            [range addObject:self[i]];
        }
    }
    
    return range;
}

@end
