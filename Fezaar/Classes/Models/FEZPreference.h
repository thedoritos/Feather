//
//  FEZPreference.h
//  Fezaar
//
//  Created by t-matsumura on 4/27/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEZPreference : NSObject

@property (nonatomic) NSNumber *lastViewedListID;

+ (instancetype)load;

- (void)save;

@end
