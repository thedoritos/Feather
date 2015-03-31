//
//  FEZTimeline.h
//  Fezaar
//
//  Created by t-matsumura on 3/20/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEZTweet.h"

@interface FEZTimeline : NSObject

@property (nonatomic, copy, readonly) NSArray *tweets;

+ (instancetype)timeline;

+ (instancetype)timelineFromTweetJsonArray:(NSArray *)tweetJsonArray;

- (FEZTimeline *)timelineInsertOrUpdateTimeline:(FEZTimeline *)timeline;

- (NSUInteger)length;
- (FEZTweet *)tweetAtIndex:(NSUInteger)index;

- (NSNumber *)sinceID;
- (NSNumber *)maxID;

@end
