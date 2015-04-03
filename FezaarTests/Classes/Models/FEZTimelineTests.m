//
//  FEZTimelineTests.m
//  Fezaar
//
//  Created by t-matsumura on 4/3/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HUKLoader.h"
#import "HUKArray.h"
#import "FEZTimeline.h"

@interface FEZTimelineTests : XCTestCase

@property (nonatomic) NSArray *statuses;

@end

@implementation FEZTimelineTests

- (void)setUp
{
    [super setUp];
    
    // Assuming get_statuses_hometimeline.json contains 20 tweets.
    _statuses = [HUKLoader loadJSONForBundle:[NSBundle bundleForClass:self.class] path:@"get_statuses_hometimeline.json"];
}

- (void)testInsertTimeline
{
    FEZTimeline *newTimeline = [FEZTimeline timelineFromTweetJsonArray:[_statuses huk_range:0  to:10]];
    FEZTimeline *oldTimeline = [FEZTimeline timelineFromTweetJsonArray:[_statuses huk_range:10 to:19]];
    
    FEZTimeline *mergedTimeline = [oldTimeline timelineInsertOrUpdateTimeline:newTimeline];
    
    XCTAssertEqual(mergedTimeline.length, 20, @"should ignore duplicated tweets");
    
//    XCTAssertEqualObjects([newTimeline tweetAtIndex:0], [mergedTimeline tweetAtIndex:0], @"should insert new tweets before old tweets");
}

@end
