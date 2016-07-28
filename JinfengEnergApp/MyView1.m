//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "MyView1.h"
#import "UUChart.h"

#import "Header.h"

@interface MyView1 ()<UUChartDataSource1>
{
    UUChart *chartView;
    NSMutableArray *_ary;
   }
@end

@implementation MyView1
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ary=[NSMutableArray array];
        for (int i=0; i<24; i++) {
            NSString *str=[NSString stringWithFormat:@"%f",i*0.083];
            [_ary addObject:str];
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
    chartView = [[UUChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 0, 320,180)
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
       
//    for (int i=0; i<num/6; i++) {
//                for (int j =0; j<6; j++) {
//                    if (j<6) {
//                        NSString * str = [NSString stringWithFormat:@"%d:%0.2d",i%24,j*10];
//                        [xTitles addObject:str];
//                        
//                    }
//                }
//                
//            }
    NSArray *array=@[@"Jan-15",@"Feb-15",@"Mar-15",@"Apr-15",@"May-15",@"Jun-15",@"Jul-15",@"Aug-15",@"Aep-15",@"Oct-15",@"Nov-15",@"Dec-15",@"Jan-15",@"Feb-15",@"Jan-15",@"Feb-15",@"Jan-15",@"Feb-15",@"Jan-15",@"Feb-15",@"Jan-15",@"Feb-15",@"Jan-15",@"Feb-15"];
    [xTitles addObjectsFromArray:array];
    NSLog(@"_max_max_max-----%d",[xTitles count]);
            return xTitles;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    
    return [self getXTitles:(int)_ary.count];
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
 
 
    
    return @[_ary];
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[[UIColor yellowColor],[UIColor whiteColor]];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(4.0, 0);
    
}
#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(UUChart *)chartView;
{
    //值得数目
    return _ary.count;
}



@end
