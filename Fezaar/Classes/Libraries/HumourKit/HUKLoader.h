//
//  HUKLoader.h
//  Fezaar
//
//  Created by t-matsumura on 4/3/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUKLoader : NSObject

+ (id)loadJSONForBundle:(NSBundle *)bundle path:(NSString*)path;

+ (id)loadJSONForPath:(NSString *)path;

@end
