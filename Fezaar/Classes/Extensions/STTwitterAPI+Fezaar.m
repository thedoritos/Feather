//
//  STTwitterAPI+Fezaar.m
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "STTwitterAPI+Fezaar.h"

@implementation STTwitterAPI (Fezaar)

- (RACSignal *)fez_getStatusesHomeTimeline
{
    return [self rac_getStatusesHomeTimelineWithCount:@"100"
                                              sinceID:nil
                                                maxID:nil
                                             trimUser:nil
                                       excludeReplies:nil
                                   contributorDetails:nil
                                      includeEntities:nil];
}

@end
