//
//  FEZTwitterAPITests.m
//  Feather
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FEZTwitterAPI.h"

@interface FEZTwitterAPITests : XCTestCase

@property (nonatomic, readonly) FEZTwitterAPI *sut;

@end

@implementation FEZTwitterAPITests

- (void)setUp {
    [super setUp];
    
    _sut = [[FEZTwitterAPI alloc] init];
}

- (void)testAuthorize {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should receive access token"];
    
    [[self.sut authorize] subscribeNext:^(STAccessToken *accessToken) {
        [expectation fulfill];
        NSLog(@"Authorized with userID: %@, screenName:%@", accessToken.userID, accessToken.screenName);
    } error:^(NSError *error) {
        XCTFail(@"it should not fail with error: %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
