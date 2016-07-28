//
//  AppDelegate.h
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.


#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) RDVTabBarController *tabBarVC;

@property (assign, nonatomic) NSUInteger isLogin;


@end

