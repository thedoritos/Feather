//
//  FEZListCollection.h
//  Fezaar
//
//  Created by t-matsumura on 3/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "FEZList.h"

@interface FEZListCollection : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *previousCursor;
@property (nonatomic, copy, readonly) NSNumber *nextCursor;

@property (nonatomic) NSArray *lists;

+ (instancetype)collection;

+ (instancetype)collectionFromJsonDictionary:(NSDictionary *)jsonDictionary;

- (NSUInteger)length;

- (FEZList *)listAtIndex:(NSUInteger)index;

@end
