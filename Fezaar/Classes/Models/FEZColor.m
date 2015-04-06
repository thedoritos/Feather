//
//  FEZColor.m
//  Fezaar
//
//  Created by t-matsumura on 4/2/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZColor.h"

@implementation FEZColor

+ (UIColor *)chitoseMidori
{
    // Chitose Midori
    return [UIColor colorWithRed:54.0f/255.0f green:80.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}

+ (UIColor *)kuchiba
{
    // Kuchiba
    return [UIColor colorWithRed:226.0f/255.0f green:148.0f/255.0f blue:59.0f/255.0f alpha:1.0f];
}

+ (UIColor *)suoh
{
    // Suoh
    return [UIColor colorWithRed:142.0f/255.0f green:53.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
}

+ (UIColor *)kon
{
    // Kon
    return [UIColor colorWithRed:15.0f/255.0f green:37.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
}

+ (UIColor *)navigationBarColor
{
    return [FEZColor chitoseMidori];
}

+ (UIColor *)navigationBarTextColor
{
    return [FEZColor kuchiba];
}

+ (UIColor *)textColor
{
    return [FEZColor kuchiba];
}

+ (UIColor *)weakTextColor
{
    return [FEZColor kuchiba];
}

+ (UIColor *)strongTextColor
{
    return [FEZColor kuchiba];
}

+ (UIColor *)backgroundColor
{
    return [FEZColor suoh];
}

+ (UIColor *)backgroundColorDark
{
    return [FEZColor kon];
}

@end
