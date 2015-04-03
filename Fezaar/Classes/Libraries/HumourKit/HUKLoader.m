//
//  HUKLoader.m
//  Fezaar
//
//  Created by t-matsumura on 4/3/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKLoader.h"

@implementation HUKLoader

+ (id)loadJSONForBundle:(NSBundle *)bundle path:(NSString*)path
{
    NSString *fileFullPath = [bundle pathForResource:path ofType:nil];
    
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:fileFullPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"HUKLoader#loadJSONForBundle error:%@", error);
        return @{};
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
    if (error) {
        NSLog(@"HUKLoader#loadJSONForBundle error:%@", error);
        return @{};
    }
    
    return json;
}

+ (id)loadJSONForPath:(NSString *)path
{
    return [self.class loadJSONForBundle:[NSBundle mainBundle] path:path];
}

@end
