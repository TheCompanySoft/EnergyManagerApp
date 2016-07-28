//
//  UULineChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"
@interface TrendanalysisLineChart : UIView
@property (nonatomic,assign) id delegate;
//xlabeL
@property (strong, nonatomic) NSArray * xLabels;
//y轴Labe
@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;
//颜色
@property (nonatomic, strong) NSArray * colors;
//x轴label的宽度
@property (nonatomic) double xLabelWidth;
@property (nonatomic) CGFloat level;
//y轴最大值和最小值
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;
//范围
@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;


-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end
