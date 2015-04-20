//
//  FEZColor.m
//  Fezaar
//
//  Created by t-matsumura on 4/2/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZColor.h"
#import "UIColor+HexString.h"

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

// Aspirin C
// https://color.adobe.com/Aspirin-C-color-theme-251864/edit/?copy=true

+ (UIColor *)darkBlue
{
    return [UIColor colorWithHexString:@"#225378"];
}

+ (UIColor *)blue
{
    return [UIColor colorWithHexString:@"#1695A3"];
}

+ (UIColor *)lightBlue
{
    return [UIColor colorWithHexString:@"#ACF0F2"];
}

+ (UIColor *)superLightBlue
{
    return [UIColor colorWithHexString:@"#F3FFE2"];
}

+ (UIColor *)orange
{
    return [UIColor colorWithHexString:@"#EB7F00"];
}

+ (UIColor *)navigationBarColor
{
    return [FEZColor darkBlue];
}

+ (UIColor *)navigationBarTextColor
{
    return [FEZColor orange];
}

+ (UIColor *)textColor
{
    return [FEZColor darkBlue];
}

+ (UIColor *)weakTextColor
{
    return [FEZColor blue];
}

+ (UIColor *)strongTextColor
{
    return [FEZColor orange];
}

+ (UIColor *)backgroundColor
{
    return [FEZColor superLightBlue];
}

+ (UIColor *)backgroundColorDark
{
    return [FEZColor blue];
}

@end
