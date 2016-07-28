//
//  ChoseOfAnalysisViewController4.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ChoseOfAnalysisViewController4.h"

@interface ChoseOfAnalysisViewController4 ()

@end

@implementation ChoseOfAnalysisViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    [self setnavigationbar];
}
//设置navigationBar
-(void)setnavigationbar{
    
    self.title=@"筛选";
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                      }];
    //返回按钮1
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 10,15)];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget : self action : @selector (backClick) forControlEvents : UIControlEventTouchUpInside ];
    self.navigationItem.leftBarButtonItem= backItem;
    
    
}
-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
