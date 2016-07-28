//
//  AppDelegate.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/18.
//  Copyright © 2015年 HKsoft. All rights reserved.
//

#import "AppDelegate.h"

#import "MonitorViewController.h"
#import "SettingViewController.h"
#import "LoginAndHomeViewContronller.h"

#import "RDVTabBarItem.h"

@interface AppDelegate (){
    UIViewController *loginAndHomeViewContronller,*monitorViewController,*settingViewController;
    UINavigationController *AnalysisVC,*HomeVC,*MonitorVC,*SettingVC;
    UIViewController *mainAnalysisViewController;
}

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupViewControllers];
    
    [self.window setRootViewController:self.viewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupViewControllers{
    
    loginAndHomeViewContronller = [[LoginAndHomeViewContronller alloc] init];
    loginAndHomeViewContronller.title = @"当日用能概况";
    HomeVC = [[UINavigationController alloc]initWithRootViewController:loginAndHomeViewContronller];
    
    monitorViewController = [[MonitorViewController alloc] init];
    monitorViewController.title = @"当日用能概况";
    MonitorVC = [[UINavigationController alloc]initWithRootViewController:monitorViewController];
    
    mainAnalysisViewController = [[UIViewController alloc]init];
    AnalysisVC = [[UINavigationController alloc]initWithRootViewController:mainAnalysisViewController];
    
    settingViewController = [[SettingViewController alloc] init];
    settingViewController.title = @"设置";
    SettingVC = [[UINavigationController alloc]initWithRootViewController:settingViewController];
    SettingVC.navigationBar.barTintColor =  [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
    
    self.tabBarVC = [[RDVTabBarController alloc] init];
    self.tabBarVC.tabBar.translucent = YES;
    
    [self.tabBarVC setViewControllers:@[HomeVC, MonitorVC,AnalysisVC,SettingVC]];
    
    self.viewController = _tabBarVC;
    
    [self customizeTabBarForController:_tabBarVC];
    
}

//设置 item属性
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [[UIImage alloc]init ];
    UIImage *unfinishedImage = [[UIImage alloc]init ];
    NSArray *tabBarItemImages = @[@"index_ico", @"monitor_ico", @"analysis_ico",@"installed_ico"];
    NSArray *tabBarItemSelectedImages = @[@"index_ico2", @"monitor_ico2", @"analysis_ico2",@"installed_ico2"];
    NSArray *tabBarItemTitles = @[@"首页",@"监测",@"分析",@"设置"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[tabBarItemSelectedImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = tabBarItemTitles[index];
        index++;
    }
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
