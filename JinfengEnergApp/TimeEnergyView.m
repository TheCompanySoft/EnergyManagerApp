//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "TimeEnergyView.h"
#import "TimeEnergyChart.h"


@interface TimeEnergyView ()<UUChartDataSource1>
{
    TimeEnergyChart *chartView;
//    值
    NSArray *_valueArray;
//    颜色
    NSArray*_colorArray;
   }
@property(nonatomic,strong)UIColor *color;
@end

@implementation TimeEnergyView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _valueArray=[NSMutableArray array];
        _colorArray=[NSMutableArray array];
    }
    return self;
}
-(void)getArray:(NSArray *)valueArray and:(NSArray *)colorArray and:(NSInteger)index {

    _valueArray=valueArray[index];
    _colorArray=colorArray;
   
    _color = [self stringTOColor:colorArray[index]];
        
    [self  configUI];
}
//将字符串转换为颜色
- (UIColor *)stringTOColor:(NSString *)str
{
    
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

//展示图表
- (void)configUI
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView = [[TimeEnergyChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 0, 320,150)
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
    NSMutableArray*dataArray=[NSMutableArray array];
    for (int i=0; i<24; i++) {
                                NSString * str = [NSString stringWithFormat:@"%d:00",i%24];
                        [dataArray addObject:str];
            }
    
    for (int i=0; i<num; i++) {
        [xTitles addObject:dataArray[i]];
    }
            return xTitles;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(TimeEnergyChart *)chart
{
    
    return [self getXTitles:(int)_valueArray.count];
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(TimeEnergyChart *)chart
{
 
 
    
    return @[_valueArray];
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(TimeEnergyChart *)chart
{
    return @[_color,[UIColor whiteColor]];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(TimeEnergyChart *)chart
{
    
    NSNumber* max1=[_valueArray valueForKeyPath:@"@max.floatValue"];
    float max2=[max1 floatValue];

    int max=[max1 intValue];
    
    if (max<=max2) {
        max=max+1;
    }
   

    return CGRangeMake(max, 0);
    
}
#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(TimeEnergyChart *)chartView;
{
    //值得数目
    return _valueArray.count;
}



@end
