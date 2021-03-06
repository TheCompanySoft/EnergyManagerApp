
//
//  EnddateView.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "EnddateView.h"
@interface EnddateView ()
{
    NSString *destDateString;
    UIDatePicker *date;
    //取消
    UIButton*_leftBtn;
    //确定
    UIButton*_rightBtn;
}

@end

@implementation EnddateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   self.backgroundColor=[UIColor colorWithRed:253.0/255 green:253.0/25 blue:253.0/25 alpha:0.95];
        [self clickBtn];
    }
    return self;
}

#pragma mark  ------ 实现按钮点击方法
- (void)clickBtn
{
    
    UILabel *headlabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 0, 240, 44.5)];
    headlabel.text=@"选择时间";
    headlabel.textColor=[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] ;
    headlabel.backgroundColor=[UIColor clearColor];
    [self addSubview:headlabel];
    UIView *headline=[[UIView alloc]initWithFrame:CGRectMake(0, 44.5, 240, 0.5)];
    headline.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];;
    [self addSubview:headline];
    //添加一个时间选择器
    date=[[UIDatePicker alloc]init];
    //设置时间选择器的颜色
    date.backgroundColor = [UIColor whiteColor];
    /**
     28      *  设置只显示中文
     29      */
    [date setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    /**
     32      *  设置只显示日期
     33      */
    date.datePickerMode=UIDatePickerModeDate;
    UIView *bottomline=[[UIView alloc]initWithFrame:CGRectMake(0, 179.5, 240, 0.5)];
    bottomline.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];;
    [self addSubview:bottomline];
    UIView *shuline=[[UIView alloc]initWithFrame:AdaptCGRectMake(119.75, 179,1, 40)];
    shuline.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];;
    [self addSubview:shuline];
    //设置工具条的frame
    _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame=AdaptCGRectMake(0, 180, 119.75, 40);
    [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.backgroundColor=[UIColor clearColor];
    [_leftBtn setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self addSubview:_leftBtn];
    _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame=AdaptCGRectMake(120.5, 180, 119, 40);
    [_rightBtn setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    _rightBtn.backgroundColor=[UIColor clearColor];
    
    date.frame = AdaptCGRectMake(0, 45,240, 134.5);
    [self addSubview:date];
    
}
#pragma mark -------  确认选择时间
- (void)clickConfirm
{
    NSDate *selected = [date date];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    //设置 时间显示方式--是否显示时分秒--以及年月日排序
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    destDateString = [dateFormatter stringFromDate:selected];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(enddateView:)]) {
        [self.delegate  enddateView:destDateString ];
    }
       [self removeFromSuperview];
}
#pragma mark -------  取消选择时间
- (void)clickCancle
{if (self.delegate &&[self.delegate respondsToSelector:@selector(endcancleBtndelegate)]) {
    [self.delegate  endcancleBtndelegate ];
}
        [self removeFromSuperview];
}
@end
