//
//  FEZMedia.h
//  Fezaar
//
//  Created by t-matsumura on 4/28/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FEZMedia : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *mediaID;

@property (nonatomic, copy, readonly) NSURL *mediaURL;

@end
