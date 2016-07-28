//
//  NavigationBarView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/25.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "NavigationBarView.h"

@implementation NavigationBarView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        [self setContent];
    }
    return self;
}
//设置内容视图
- (void)setContent{
    UIImage *image = [UIImage imageNamed:@"nav_bg"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self addSubview:imageView];
    imageView.frame = self.frame;

    _title_Lable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(50, 20, 220, 40)];
    _title_Lable.textAlignment = NSTextAlignmentCenter;
//    _title_Lable.backgroundColor = [UIColor redColor];
    _title_Lable.textColor = [UIColor whiteColor];
    _title_Lable.font = [UIFont systemFontOfSize:16];
    _title_Lable.text = @"yyyyy";
    [self addSubview:_title_Lable];
    
    _navigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _navigationBarButton.backgroundColor = [UIColor redColor];
    _navigationBarButton.frame = AdaptCGRectMake(280, 22, 40, 40);
    [_navigationBarButton setImage:[UIImage imageNamed:@"pic1"] forState:UIControlStateNormal];
    [_navigationBarButton setImage:[UIImage imageNamed:@"pic1"] forState:UIControlStateSelected];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _navigationBarButton.backgroundColor = [UIColor redColor];
    _leftButton.frame = AdaptCGRectMake(0, 22, 40, 40);
    [_leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateSelected];
    
    _rightWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _navigationBarButton.backgroundColor = [UIColor redColor];
    _rightWarningButton.frame = AdaptCGRectMake(252, 22, 40, 40);
    
    [_rightWarningButton setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
    [_rightWarningButton setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateSelected];
    
    _BBValuesLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(24, 8, 10, 10)];
    _BBValuesLable.layer.cornerRadius = _BBValuesLable.frame.size.height/2;
    _BBValuesLable.layer.masksToBounds = YES;
    _BBValuesLable.backgroundColor = [UIColor redColor];
    _BBValuesLable.text = @"0";
    _BBValuesLable.tag = 1;
    _BBValuesLable.textColor = [UIColor whiteColor];
    _BBValuesLable.textAlignment = NSTextAlignmentCenter;
    _BBValuesLable.font = [UIFont systemFontOfSize:7];
    [_BBValuesLable adjustsFontSizeToFitWidth];
    [_rightWarningButton addSubview:_BBValuesLable];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
