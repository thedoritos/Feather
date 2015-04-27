//
//  FEZPreference.m
//  Fezaar
//
//  Created by t-matsumura on 4/27/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZPreference.h"

static NSString * const kLastViewedListID = @"LastViewedListIDKey";

@implementation FEZPreference

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        _lastViewedListID = [defaults objectForKey:kLastViewedListID];
    }
    return self;
}

+ (instancetype)load
{
    return [[FEZPreference alloc] init];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_lastViewedListID forKey:kLastViewedListID];
    [defaults synchronize];
}

@end
