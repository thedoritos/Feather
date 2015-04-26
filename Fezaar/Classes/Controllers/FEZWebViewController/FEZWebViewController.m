//
//  FEZWebViewController.m
//  Fezaar
//
//  Created by t-matsumura on 4/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZWebViewController.h"

@interface FEZWebViewController ()

@property (nonatomic, copy, readonly) NSURL *url;

@end

@implementation FEZWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

@end
