//
//  FEZDateFormatter.m
//  Fezaar
//
//  Created by t-matsumura on 4/18/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <NSDate-Extensions/NSDate-Utilities.h>

#import "FEZDateFormatter.h"

@implementation FEZDateFormatter

+ (NSString *)formatDate:(NSDate *)date now:(NSDate *)now
{
    NSInteger days = [date daysBeforeDate:now];
    if (days > 6) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        return [formatter stringFromDate:date];
    }
    
    if (days > 0) {
        // TODO: localize format.
        NSString *format = @"%dd";
        return [NSString stringWithFormat:format, days];
    }
    
    NSInteger hours = [date hoursBeforeDate:now];
    if (hours > 0) {
        // TODO: localize format.
        NSString *format = @"%dh";
        return [NSString stringWithFormat:format, hours];
    }
    
    NSInteger minutes = [date minutesBeforeDate:now];
    if (minutes > 0) {
        // TODO: localize format.
        NSString *format = @"%dm";
        return [NSString stringWithFormat:format, minutes];
    }
    
    NSInteger seconds = [now timeIntervalSinceDate:date];
    // TODO: localize format.
    NSString *format = @"%ds";
    return [NSString stringWithFormat:format, seconds];
}

+ (NSString *)formatDate:(NSDate *)date
{
    return [[self class] formatDate:date now:[NSDate date]];
}

@end
