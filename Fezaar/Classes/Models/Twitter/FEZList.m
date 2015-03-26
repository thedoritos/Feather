//
//  FEZList.m
//  Fezaar
//
//  Created by t-matsumura on 3/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZList.h"

@implementation FEZList

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"listID" : @"id",
        @"listDescription" : @"description"
    };
}

@end
