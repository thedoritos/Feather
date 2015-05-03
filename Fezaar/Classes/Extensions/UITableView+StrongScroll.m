//
//  UITableView+StrongScroll.m
//  tico-twitter-ios
//
//  Created by t-matsumura on 2/25/15.
//
//

#import "UITableView+StrongScroll.h"

@implementation UITableView (StrongScroll)

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end
