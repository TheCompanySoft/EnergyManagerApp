//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "FinishedProductView.h"
#import "FinishedProductChart.h"

@interface FinishedProductView ()<UUChartDataSource1>
{
    FinishedProductChart *finishedchartView;
    NSArray *_specificary;
    NSArray *_stantspecificary;
    NSArray*_datearray;
   }
@end

@implementation FinishedProductView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _specificary=[NSMutableArray array];
         _stantspecificary=[NSMutableArray array];
          _datearray=[NSMutableArray array];
    }
    return self;
}
-(void)getdateArray:(NSArray*)dateArray and:(NSArray*)standardSpecificArray and:(NSArray*)specificArray{
    _specificary=specificArray;
    _stantspecificary=standardSpecificArray;
    _datearray=dateArray;
[self  configUI];
}
//展示图表
- (void)configUI
{
    if (finishedchartView) {
        [finishedchartView removeFromSuperview];
        finishedchartView = nil;
    }
    finishedchartView = [[FinishedProductChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 0, 320,180)
                                               withSource:self
                                                withStyle:UUChartLineStyle];
    
    
        [finishedchartView showInView:self];
    
}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    if (xTitles.count!=0) {
        [xTitles removeAllObjects];
    }
       
    
    [xTitles addObjectsFromArray:_datearray];
    
    return xTitles;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(FinishedProductChart *)chart
{
    
    return [self getXTitles:(int)_specificary.count];
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(FinishedProductChart *)chart
{
 
 
    
    return @[_specificary,_stantspecificary];
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(FinishedProductChart *)chart
{
    return @[[UIColor yellowColor],[UIColor redColor]];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(FinishedProductChart *)chart
{
    NSNumber* max=[_specificary valueForKeyPath:@"@max.floatValue"];
    NSNumber* max2=[_stantspecificary valueForKeyPath:@"@max.floatValue"];
   
    
    //纵坐标最大值和最小值
    
    float max1=[max floatValue];
    float max3=[max2 floatValue];
    if (max3>max1) {
        max1=max3;
    }
    if (max1<1) {
        max1=max1+1;
    }
  
    return CGRangeMake(max1, 0);
    
}
#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(FinishedProductChart *)chartView;
{
    //值得数目
    return _specificary.count;
}



@end
