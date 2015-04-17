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
#import "FEZListCollection.h"

@interface FEZTwitter : NSObject

- (RACSignal *)authorize;

- (RACSignal *)fetchHomeTimeline;

- (RACSignal *)fetchHomeTimelineLaterThanTimeline:(FEZTimeline *)timeline;
- (RACSignal *)fetchHomeTimelineOlderThanTimeline:(FEZTimeline *)timeline;

- (RACSignal *)fetchLists;
- (RACSignal *)fetchListTimeline:(FEZList *)list;

- (RACSignal *)fetchListTimeline:(FEZList *)list laterThanTimeline:(FEZTimeline *)timeline;
- (RACSignal *)fetchListTimeline:(FEZList *)list olderThanTimeline:(FEZTimeline *)timeline;

@end
