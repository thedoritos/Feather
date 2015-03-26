//
//  FEZList.h
//  Fezaar
//
//  Created by t-matsumura on 3/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FEZList : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *listID;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *listDescription;

@end
