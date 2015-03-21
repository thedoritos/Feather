//
//  HUKAccountStoreTests.m
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HUKTwitterAccountStore.h"
#import "HUKTwitterAccountStore+RACSupport.h"
#import "HUKArray.h"

@interface HUKAccountStoreTests : XCTestCase

@property (nonatomic) HUKTwitterAccountStore *sut;

@end

@implementation HUKAccountStoreTests

- (void)setUp {
    [super setUp];
    
    _sut = [[HUKTwitterAccountStore alloc] init];
}

- (void)testRequestAccounts {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should receive accounts"];
    
    [[_sut rac_requestAccounts] subscribeNext:^(NSArray *accounts) {
        [expectation fulfill];
        XCTAssertGreaterThanOrEqual(accounts.count, 2, @"should have multi accounts for testing. \
                                    Please register 2 or more accounts from Settings > Twitter > Add Account");
    } error:^(NSError *error) {
        XCTFail(@"should not fail with error: %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testSwitchAccounts {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should receive switched account"];
    
    __block NSArray   *accounts;
    __block ACAccount *currentAccount;
    __block ACAccount *nextAccount;
    
    [[[[[_sut rac_requestAccounts]
     flattenMap:^(NSArray *response) {
         XCTAssertGreaterThanOrEqual(response.count, 2, @"should have multi accounts (for testing)");
         
         accounts = response;
         currentAccount = [accounts huk_sample];
         
         return [_sut rac_registerCurrentAccount:currentAccount];
     }]
     flattenMap:^(ACAccount *response) {
         XCTAssertEqualObjects(response.username, currentAccount.username, @"should set default account");
         
         nextAccount = [[accounts
                         huk_filter:^BOOL(ACAccount *account) {
                             return ![account.username isEqualToString:currentAccount.username];
                         }]
                         huk_sample];
         
         return [_sut rac_registerCurrentAccount:nextAccount];
     }]
     flattenMap:^(ACAccount *response) {
         XCTAssertEqualObjects(response.username, nextAccount.username, @"should switch account");
         
         return [_sut rac_requestCurrentAccount];
     }]
     subscribeNext:^(ACAccount *response) {
        [expectation fulfill];
         XCTAssertEqualObjects(response.username, nextAccount.username, @"should switch account");
     }
     error:^(NSError *error) {
         XCTFail(@"should not fail with error: %@", error);
     }];
    
    [self waitForExpectationsWithTimeout:500 handler:nil];
}

@end
