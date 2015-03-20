//
//  FEZTwitterAPI.h
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STTwitterAPI+Fezaar.h"
#import "FEZTimeline.h"

@interface FEZTwitterAPI : NSObject

- (RACSignal *)authorize;

- (RACSignal *)fetchHomeTimeline;

- (RACSignal *)fetchHomeTimelineBackground;

@end
