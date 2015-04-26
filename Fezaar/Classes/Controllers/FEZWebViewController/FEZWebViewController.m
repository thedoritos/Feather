//
//  FEZWebViewController.m
//  Fezaar
//
//  Created by t-matsumura on 4/26/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <PocketAPI/PocketAPI.h>
#import "FEZWebViewController.h"

@interface FEZWebViewController ()

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) FEZTweet *tweet;

@end

@implementation FEZWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"shared URL";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveToPocket)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (instancetype)initWithURL:(NSURL *)url tweet:(FEZTweet *)tweet
{
    self = [super init];
    if (self) {
        _url = url;
        _tweet = tweet;
    }
    return self;
}

- (void)saveToPocket
{
    [[PocketAPI sharedAPI] saveURL:self.url withTitle:self.tweet.text tweetID:[self.tweet.statusID stringValue] handler:^(PocketAPI *api, NSURL *url, NSError *error) {
        NSLog(@"Saved to Pocket url:%@, error:%@", url, error);
    }];
}

@end
