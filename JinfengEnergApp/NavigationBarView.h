//
//  NavigationBarView.h
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/25.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIView
//标题
@property (nonatomic, strong) UILabel *title_Lable;
//右按钮2
@property (nonatomic, strong) UIButton *navigationBarButton;
//提醒数字
@property (nonatomic, strong)UILabel *BBValuesLable;
//左按钮
@property (nonatomic, strong) UIButton *leftButton;
//右按钮1
@property (nonatomic, strong) UIButton *rightWarningButton;

@end
