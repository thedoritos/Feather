//
//  FEZDateFormatter.h
//  Fezaar
//
//  Created by t-matsumura on 4/18/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEZDateFormatter : NSObject

+ (NSString *)formatDate:(NSDate *)date now:(NSDate *)now;
+ (NSString *)formatDate:(NSDate *)date;

@end
