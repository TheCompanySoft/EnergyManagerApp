//
//  UUChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "UUColor.h"
#import "UULineChart.h"

//类型
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class UUChart;
@protocol UUChartDataSource1 <NSObject>


//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart;

//数值多重数组
//- (NSArray *)UUChart_yValueArray1:(UUChart1 *)chart;

@optional


//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

#pragma mark 折线图专享功能

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

@end


@interface UUChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource1>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end
