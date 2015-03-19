//
//  FEZConfig.h
//  Fezaar
//
//  Created by t-matsumura on 2/10/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEZConfig : NSObject

@property (nonatomic, copy, readonly) NSString *consumerKey;
@property (nonatomic, copy, readonly) NSString *consumerSecret;

+ (instancetype)defaultConfig;

@end
