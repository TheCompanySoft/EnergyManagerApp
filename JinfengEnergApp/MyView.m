//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "MyView.h"
#import "UUChart1.h"

#import "Header.h"

@interface MyView ()<UUChartDataSource1>
{
    UUChart1 *chartView;
    NSMutableArray *_ary;
     NSMutableArray *_ary1;
   }
@end

@implementation MyView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ary=[NSMutableArray array];
        _ary1=[NSMutableArray array];
        for (int i=0; i<24; i++) {
            NSString *str=[NSString stringWithFormat:@"%f",i*0.5];
            NSString *str1=[NSString stringWithFormat:@"%f",i*0.5+5];
            [_ary addObject:str];
            [_ary1 addObject:str1];
        }
        [self  configUI];
    }
    return self;
}

//展示图表
- (void)configUI
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView = [[UUChart1 alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 20, 320,180)
                                               withSource:self
                                                withStyle:UUChartLineStyle];
    
    
        [chartView showInView:self];
    
}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    if (xTitles.count!=0) {
        [xTitles removeAllObjects];
    }
       
    for (int i=0; i<num/6; i++) {
                for (int j =0; j<6; j++) {
                    if (j<6) {
                        NSString * str = [NSString stringWithFormat:@"%d:%0.2d",i%24,j*10];
                        [xTitles addObject:str];
                        
                    }
                }
                
            }
  
    NSLog(@"_max_max_max-----%d",[xTitles count]);
            return xTitles;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart1 *)chart
{
    
    return [self getXTitles:(int)_ary.count];
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart1 *)chart
{
 
 
    
    return @[_ary1,_ary];
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart1 *)chart
{
    return @[[UIColor blueColor],[UIColor orangeColor],[UIColor whiteColor],];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart1 *)chart
{
    return CGRangeMake(60, 0);
    
}
#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(UUChart1 *)chartView;
{
    //值得数目
    return _ary.count;
}



@end
