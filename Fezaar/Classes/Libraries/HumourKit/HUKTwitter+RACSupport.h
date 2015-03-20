//
//  HUKTwitter+RACSupport.h
//  Fezaar
//
//  Created by t-matsumura on 3/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HUKTwitter.h"

@interface HUKTwitter (RACSupport)

- (RACSignal *)rac_authorize;

- (RACSignal *)rac_getStatusesHomeTimeline;

@end
