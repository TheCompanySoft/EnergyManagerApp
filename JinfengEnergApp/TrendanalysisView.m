//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//
//
#import "TrendanalysisView.h"
#import "TrendanalysisChart.h"

#import "Header.h"

@interface TrendanalysisView ()<UUChartDataSource1>
{
    //表图
    TrendanalysisChart *chartView;
    //时间
    NSArray *_dateary;
    NSMutableArray *_allAry;
    //最大值和最小值数组
    NSMutableArray*_minandMaxarray;
    //颜色
    NSMutableArray *_colors;
    UILabel*_lable;
   }
@end

@implementation TrendanalysisView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dateary=[NSArray array];
        _allarray=[NSMutableArray array];
        _minandMaxarray=[NSMutableArray array];
        _colors=[NSMutableArray array];

        [self  configUI];
    }
    return self;
}
-(void)getAllArray:(NSArray *)allArray andDate:(NSArray *)arrray andColors:(NSArray *)colors{

 
    for (int i=0; i<colors.count; i++) {
        UIColor *color=[self stringTOColor:colors[i]];
        [_colors addObject:color];
    }
    _allarray=allArray;
   
    for (NSArray*arr in allArray) {
        NSNumber* max1=[arr valueForKeyPath:@"@max.floatValue"];
        NSNumber* min1=[arr valueForKeyPath:@"@min.floatValue"];
        [_minandMaxarray addObject:max1];
        [_minandMaxarray addObject:min1];
    }
    _dateary=arrray;
    [self configUI];
}
//展示图表
- (void)configUI
{
    //纵坐标上方的label
    _lable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(5, 6, 28, 11)];
    _lable.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.1];
    _lable.text=@"数量";
    _lable.layer.cornerRadius=_lable.frame.size.height/2;
    _lable.layer.masksToBounds=YES;
    _lable.font=[UIFont systemFontOfSize:8];
    _lable.textAlignment=NSTextAlignmentCenter;
    _lable.textColor=[UIColor whiteColor];
    if (_dateary.count>0) {
       [self addSubview:_lable]; 
    }
    
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView = [[TrendanalysisChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 20, 320,180)
                                               withSource:self
                                                withStyle:UUChartLineStyle];
    
    
        [chartView showInView:self];
    
}
- (NSArray *)getXTitles:(int)num
{
return _dateary;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(TrendanalysisChart *)chart
{
    
    return [self getXTitles:(int)_dateary.count];
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(TrendanalysisChart *)chart
{
  
    return _allarray;
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(TrendanalysisChart *)chart
{
    
    return _colors;
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(TrendanalysisChart *)chart
{
    NSNumber* max=[_minandMaxarray valueForKeyPath:@"@max.floatValue"];
    
   // NSNumber* min=[_minandMaxarray valueForKeyPath:@"@min.floatValue"];
     
//    //纵坐标最大值和最小值
//    int min1=[min intValue];
    if (_minandMaxarray.count>0) {
        int max1=[max intValue];
        if (max1<1) {
            max1=max1+1;
        }
        return CGRangeMake(max1, 0);
    }else{
    
    
    return CGRangeMake(-20, -2);;
    }
   // return CGRangeMake(max1, 0);
    
}
#pragma mark - FYChartViewDataSource
//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(TrendanalysisChart *)chartView;
{
    //值得数目
    return _dateary.count;
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



@end
