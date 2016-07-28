//
//  UULineChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "TimeEnergyLineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#define UULabelHeight    10

@interface TimeEnergyLineChart ()<UIScrollViewDelegate>
{
    //横向滚动
    UIScrollView *myScrollView;
    UUChartLabel * _label;
    
  
}
@property(nonatomic,assign)float labelsize;
@property(nonatomic,assign)float a;
@property(nonatomic,strong)NSArray *labelsArray;
//最大
@property(nonatomic,assign)float max;
@end
@implementation TimeEnergyLineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _yValues=[NSArray array];
       
        self.clipsToBounds = YES;
        //添加滚动视图
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIUtils getWindowWidth], frame.size.height)];
        myScrollView.bounces=NO;
        myScrollView.delegate=self;
        myScrollView.showsHorizontalScrollIndicator =NO;
      
        [self addSubview:myScrollView];
    
    }
    return self;
}
//设置y值
-(void)setYValues:(NSArray *)yValues
{
        _yValues = yValues ;
        [self setYLabels:yValues];

    }

//添加y轴的label
-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 10000;
    
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    _level = (_yValueMax-_yValueMin)/3.0;
    
    CGFloat chartCavanHeight = 150*[UIUtils getWindowHeight]/568-25;
    CGFloat levelHeight = chartCavanHeight/3.0;
    
    for (int i=0; i<4; i++) {
        //y轴label
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(5*[UIUtils getWindowWidth]/320,chartCavanHeight-i*levelHeight,35*[UIUtils getWindowWidth]/320, 20*[UIUtils getWindowHeight]/568)];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:11];
        label.backgroundColor=[UIColor clearColor];
      label.text = [NSString stringWithFormat:@"%.1f",(_level * i+_yValueMin)];
     
        [self addSubview:label];
    }
  
}
//x轴
-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    //label的数量
    _xLabels = xLabels;
    
    CGFloat num ;
        num=5;
    _xLabelWidth = myScrollView.frame.size.width/ num;
    //x轴label的
    for (int i=0; i<xLabels.count; i++) {
        
        NSString *labelText = xLabels[i];
        _label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height- UULabelHeight, _xLabelWidth, UULabelHeight)];
        _label.text = labelText;
        _label.font=[UIFont systemFontOfSize:12];
        
        _label.textColor=[UIColor whiteColor];
        [myScrollView addSubview:_label];
        _label.backgroundColor=[UIColor clearColor];
        [_chartLabelsForX addObject:_label];
        
   
    }
    _max = [xLabels count]*_xLabelWidth;
  
        myScrollView.contentSize = CGSizeMake(_max, self.frame.size.height);
    
    }

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}



-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[0];
        
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i;
        NSInteger min_i;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[0] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 1.8;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        [myScrollView.layer addSublayer:_chartLine];
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = ( _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        
        BOOL isShowMaxAndMinPoint = YES;
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                
                
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
            }
            index += 1;
        }
    
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:0] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:0] CGColor];
        }else{
            _chartLine.strokeColor = [[UIColor whiteColor] CGColor];
        }
        
        _chartLine.strokeEnd = 1.0;
    }
}
//添加点视图
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(4, 5,10, 10)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius =5;
    view.layer.borderWidth=2;
    
    if (index==3) {
       
        view.frame=CGRectMake(4, 5,14, 14);
        view.layer.cornerRadius =7;
        view.layer.borderWidth=2;
    }
    view.layer.borderColor = [[_colors objectAtIndex:0] CGColor];
    
    if (isHollow) {
        view.backgroundColor = [_colors objectAtIndex:0];
    }else{
        view.backgroundColor = [_colors objectAtIndex:0];
    }
    
    [myScrollView addSubview:view];
}
//返回数组数据
- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
