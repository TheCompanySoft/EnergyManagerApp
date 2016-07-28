//
//  UULineChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

@interface FinishedProductLineChart : UIView
@property (nonatomic,assign) id delegate;
//x轴的label
@property (strong, nonatomic) NSArray * xLabels;
//y轴的label
@property (strong, nonatomic) NSArray * yLabels;
//y轴的参数
@property (strong, nonatomic) NSArray * yValues;
//颜色数组
@property (nonatomic, strong) NSArray * colors;
//x轴label的宽度
@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat level;
//最大值和最小值
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;
//范围
@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;


-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end
