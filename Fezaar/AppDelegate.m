//
//  AppDelegate.m
//  Fezaar
//
//  Created by thedoritos on 2/5/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <ECSlidingViewController/ECSlidingViewController.h>
#import "AppDelegate.h"
#import "FEZTwitter.h"
#import "FEZListCollectionViewController.h"
#import "FEZListViewController.h"
#import "FEZColor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];    
    [[UINavigationBar appearance] setBarTintColor:[FEZColor navigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[FEZColor navigationBarTextColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [FEZColor navigationBarTextColor] }];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    FEZListCollectionViewController *listCollectionViewController = [[FEZListCollectionViewController alloc] init];
    FEZListViewController *listViewController = [[FEZListViewController alloc] init];
    
    ECSlidingViewController *mainViewController = [ECSlidingViewController slidingWithTopViewController:[[UINavigationController alloc] initWithRootViewController:listViewController]];
    
    mainViewController.underLeftViewController = [[UINavigationController alloc] initWithRootViewController:listCollectionViewController];
    mainViewController.underLeftViewController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    mainViewController.anchorRightRevealAmount = 280;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Start background fetch");
    
    FEZTwitter *twitter = [[FEZTwitter alloc] init];
    
    [[twitter fetchHomeTimeline] subscribeNext:^(FEZTimeline *timeline) {
        
        NSLog(@"Fetched home timeline with tweets: %@, count: %lu", timeline.tweets, (unsigned long)timeline.tweets.count);
        NSLog(@"Completed background fetch");
        
        completionHandler(UIBackgroundFetchResultNewData);
    } error:^(NSError *error) {
        
        NSLog(@"Failed background fetch");
        
        completionHandler(UIBackgroundFetchResultFailed);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
