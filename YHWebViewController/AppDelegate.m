//
//  AppDelegate.m
//  YHWebViewController
//
//  Created by YHIOS002 on 16/11/29.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RNCachingURLProtocol.h"
#import "VC1.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.webView离线缓存
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    //2.setupUserAgent
    UIWebView *tempWebV = [[UIWebView alloc] init];
    NSString *sAgent = [tempWebV stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *userAgent = [NSString stringWithFormat:@"%@; ShuiDao /%f",sAgent,2.0];
    [tempWebV stringByEvaluatingJavaScriptFromString:userAgent];
    NSDictionary*dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
    //3.设置rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    VC1 *vc = [[VC1 alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    nav.navigationBar.titleTextAttributes = attributes;
    UIColor * color = [UIColor colorWithRed:0.f green:191.f / 255 blue:143.f / 255 alpha:1];
    nav.navigationBar.barTintColor = color;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
