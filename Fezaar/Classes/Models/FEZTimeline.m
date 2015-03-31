//
//  FEZTimeline.m
//  Fezaar
//
//  Created by t-matsumura on 3/20/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZTimeline.h"
#import "HUKArray.h"

@implementation FEZTimeline

- (instancetype)initWithTweets:(NSArray *)tweets
{
    self = [super init];
    if (self) {
        _tweets = tweets;
    }
    return self;
}

+ (instancetype)timeline
{
    return [[self class] timelineFromTweetJsonArray:@[]];
}

+ (instancetype)timelineFromTweetJsonArray:(NSArray *)tweetJsonArray
{
    NSError *error = nil;
    NSArray *tweets = [MTLJSONAdapter modelsOfClass:[FEZTweet class] fromJSONArray:tweetJsonArray error:&error];
    
    if (error) {
        NSLog(@"Error: failed to parse json array:%@ with error:%@", tweetJsonArray, error);
    }
    
    return [[[self class] alloc] initWithTweets:tweets];
}

- (FEZTimeline *)timelineInsertOrUpdateTimeline:(FEZTimeline *)timeline
{
    NSArray *tweets = [self.tweets huk_unique:timeline.tweets comparator:^NSComparisonResult(FEZTweet *a, FEZTweet *b) {
        return [a.statusID compare:b.statusID];
    }];
    
    [tweets sortedArrayUsingComparator:^NSComparisonResult(FEZTweet *a, FEZTweet *b) {
        return [a.statusID compare:b.statusID];
    }];
    
    return [[FEZTimeline alloc] initWithTweets:tweets];
}

- (NSUInteger)length
{
    return self.tweets.count;
}

- (FEZTweet *)tweetAtIndex:(NSUInteger)index
{
    return self.tweets[index];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"FEZTimeline tweets:%@", self.tweets];
}

- (NSNumber *)sinceID
{
    if (self.tweets.count == 0) {
        return nil;
    }
    
    return ((FEZTweet *)self.tweets.firstObject).statusID;
}

- (NSNumber *)maxID
{
    if (self.tweets.count == 0) {
        return nil;
    }
    
    return ((FEZTweet *)self.tweets.lastObject).statusID;
}

@end
