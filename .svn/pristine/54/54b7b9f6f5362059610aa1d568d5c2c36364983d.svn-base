//
//  ChooseOfAnalysisViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/13.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ChooseOfAnalysisViewController.h"

@interface ChooseOfAnalysisViewController (){
    XNTabBarViewController *tabbarVC;
}

@end

@implementation ChooseOfAnalysisViewController

- (void)viewWillAppear:(BOOL)animated{
    if ([tabbarVC isKindOfClass:[XNTabBarViewController class]])
    {
        tabbarVC.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([tabbarVC isKindOfClass:[XNTabBarViewController class]])
    {
        [tabbarVC.otherChoiceView removeFromSuperview];
        tabbarVC.tabBar.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"big_background"]];

    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    // Do any additional setup after loading the view.
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
