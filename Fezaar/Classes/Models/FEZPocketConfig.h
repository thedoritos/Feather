//
//  FEZPocketConfig.h
//  Fezaar
//
//  Created by t-matsumura on 4/25/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEZPocketConfig : NSObject

@property (nonatomic, copy, readonly) NSString *consumerKey;
@property (nonatomic, copy, readonly) NSString *urlScheme;

+ (instancetype)configWithDictionary:(NSDictionary *)dictionary;

- (void)prepare;

@end
