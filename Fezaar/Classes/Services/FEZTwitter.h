//
//  FEZTwitter.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "HUKTwitter.h"
#import "HUKTwitter+RACSupport.h"
#import "FEZTimeline.h"

@interface FEZTwitter : NSObject

- (RACSignal *)authorize;

- (RACSignal *)fetchHomeTimeline;

- (RACSignal *)fetchLists;

@end
