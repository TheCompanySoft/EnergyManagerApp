//
//  UUChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//
#import "FinishedProductChart.h"

@interface FinishedProductChart ()

@property (strong, nonatomic) FinishedProductLineChart * lineChart;


@property (assign, nonatomic) id<UUChartDataSource1> dataSource;

@end

@implementation FinishedProductChart

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource1>)dataSource withStyle:(UUChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = NO;
    }
    return self;
}
//
-(void)setUpChart{
	if (self.chartStyle == UUChartLineStyle) {
        if(!_lineChart){
            _lineChart = [[FinishedProductLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
 
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_lineChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
        [_lineChart setYValues:[self.dataSource UUChart_yValueArray:self]];
		[_lineChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
        
		[_lineChart strokeChart];

	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end
