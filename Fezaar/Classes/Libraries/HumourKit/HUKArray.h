//
//  HUKArray.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Action)(id e);
typedef BOOL(^Predicate)(id e);
typedef NSComparisonResult(^Comparator)(id a, id b);

@interface HUKArray : NSObject

@end

@interface NSArray (HUKArray)

- (BOOL)huk_isEmpty;

- (BOOL)huk_any:(Predicate)predicate;

- (BOOL)huk_none:(Predicate)predicate;

- (id)huk_match:(Predicate)predicate;

- (id)huk_sample;

- (instancetype)huk_filter:(Predicate)predicate;

- (instancetype)huk_unique:(NSArray *)comparison comparator:(Comparator)comparator;

- (instancetype)huk_range:(NSInteger)from to:(NSInteger)to;

@end
