/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "AppDelegate.h"
#import "ModelSelectViewController.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [theAppDelegate applicationDidFinishLaunchingWithOptions:launchOptions];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //首先启动注册页面
    //ModelSelectViewController *registerViewController = [[[ModelSelectViewController alloc] init] autorelease];
    //UINavigationController *navigationBar = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    UINavigationController *navigationBar = [[UINavigationController alloc] init];
    CGFloat navBarHeight = 55.0f;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f, navBarHeight);
    [navigationBar.navigationBar setFrame:frame];
    self.window.rootViewController = navigationBar;
    [navigationBar release];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [theAppDelegate applicationDidEnterBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [theAppDelegate applicationWillResignActive];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [theAppDelegate applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [theAppDelegate applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [theAppDelegate applicationWillTerminate];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [theAppDelegate applicationDidReceiveLocalNotification:notification];
}

@end
