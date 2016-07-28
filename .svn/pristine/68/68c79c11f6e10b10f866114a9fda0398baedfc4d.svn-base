//
//  UUChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendanalysisChart.h"
#import "UUColor.h"
#import "TrendanalysisLineChart.h"

//类型
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class TrendanalysisChart;
@protocol UUChartDataSource1 <NSObject>


//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(TrendanalysisChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(TrendanalysisChart *)chart;

//数值多重数组
//- (NSArray *)UUChart_yValueArray1:(TrendanalysisChart *)chart;

@optional


//颜色数组
- (NSArray *)UUChart_ColorArray:(TrendanalysisChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(TrendanalysisChart *)chart;

#pragma mark 折线图专享功能

//判断显示横线条
- (BOOL)UUChart:(TrendanalysisChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

@end


@interface TrendanalysisChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource1>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end
