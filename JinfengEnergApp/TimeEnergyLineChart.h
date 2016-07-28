//
//  UULineChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

@interface TimeEnergyLineChart : UIView
@property (nonatomic,assign) id delegate;
//x轴的Label
@property (strong, nonatomic) NSArray * xLabels;
//y轴的Label
@property (strong, nonatomic) NSArray * yLabels;
//y轴值得所在数组
@property (strong, nonatomic) NSArray * yValues;
//颜色
@property (nonatomic, strong) NSArray * colors;
//x轴label的快读
@property (nonatomic) CGFloat xLabelWidth;
//值得处理
@property (nonatomic) CGFloat level;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;
//范围
@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;


-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end
