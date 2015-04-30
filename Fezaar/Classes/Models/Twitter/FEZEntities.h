//
//  FEZEntities.h
//  Fezaar
//
//  Created by t-matsumura on 4/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "FEZMedia.h"

@interface FEZEntities : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *urls;

@property (nonatomic, copy, readonly) NSArray *media;

- (BOOL)containsURL;
- (BOOL)containsMedia;

@end
