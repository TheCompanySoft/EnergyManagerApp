//
//  LoginAndHomeViewContronller.m
//  JinfengEnergApp
//
//  Created by BlackChen on 16/1/18.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "LoginAndHomeViewContronller.h"
@interface LoginAndHomeViewContronller (){
    UIViewController *homeViewController,*loginAccountViewController;
    RDVTabBarController *tabbarVC;
//本地
    NSUserDefaults *defaults;
}

@end

@implementation LoginAndHomeViewContronller
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    homeViewController = [[HomeViewController alloc]init];
    loginAccountViewController = [[LoginAccountViewController alloc]init];
    
    [self addChildViewController:homeViewController];
    [self addChildViewController:loginAccountViewController];
    
        [self.view addSubview:loginAccountViewController.view];
        self.currentVC = loginAccountViewController;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notttt:) name:@"isLogin" object:@"isLogin"];
}
#pragma mark 通知方法
- (void)notttt:(NSNotification *)not{
    NSString *str = [not.userInfo objectForKey:@"isLogin"];
    tabbarVC.selectedIndex = 0;
    if ([str isEqual:@"1"]) {
        [self replaceController:self.currentVC newController:homeViewController];
    }else{
        [self replaceController:self.currentVC newController:loginAccountViewController];
    }
    
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
