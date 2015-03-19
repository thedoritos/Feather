//
//  STTwitterAPI+Fezaar.h
//  Fezaar
//
//  Created by thedoritos on 2/8/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitterAPI+RACSignalSupport.h"

@interface STTwitterAPI (Fezaar)

- (RACSignal *)fez_getStatusesHomeTimeline;

@end
