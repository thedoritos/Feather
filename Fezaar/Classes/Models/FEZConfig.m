//
//  FEZConfig.m
//  Fezaar
//
//  Created by t-matsumura on 2/10/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZConfig.h"

@implementation FEZConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString     *secretsPath = [[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"];
        NSDictionary *secrets     = [[NSDictionary alloc] initWithContentsOfFile:secretsPath];
        
        _consumerKey    = secrets[@"TwitterAPI"][@"ConsumerKey"];
        _consumerSecret = secrets[@"TwitterAPI"][@"ConsumerSecret"];
    }
    return self;
}

+ (instancetype)defaultConfig
{
    return [[FEZConfig alloc] init];
}

@end
