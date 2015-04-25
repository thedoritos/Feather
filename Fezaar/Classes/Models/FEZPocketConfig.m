//
//  FEZPocketConfig.m
//  Fezaar
//
//  Created by t-matsumura on 4/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <PocketAPI/PocketAPI.h>
#import "FEZPocketConfig.h"

@implementation FEZPocketConfig

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _consumerKey = dictionary[@"ConsumerKey"];
        _urlScheme = dictionary[@"URLScheme"];
    }
    return self;
}

+ (instancetype)configWithDictionary:(NSDictionary *)dictionary
{
    return [[FEZPocketConfig alloc] initWithDictionary:dictionary];
}

- (void)prepare
{
    [[PocketAPI sharedAPI] setURLScheme:self.urlScheme];
    [[PocketAPI sharedAPI] setConsumerKey:self.consumerKey];
}

@end
