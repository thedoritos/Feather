//
//  FEZWebViewController.h
//  Fezaar
//
//  Created by t-matsumura on 4/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEZTweet.h"

@interface FEZWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (instancetype)initWithURL:(NSURL *)url tweet:(FEZTweet *)tweet;

@end
