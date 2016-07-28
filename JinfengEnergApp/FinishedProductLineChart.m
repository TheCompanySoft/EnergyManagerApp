//
//  UULineChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "FinishedProductLineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"


#define UULabelHeight    10

@interface FinishedProductLineChart ()<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UUChartLabel * _label;
    UIView *_pointview;
    
  
}
@property(nonatomic,assign)float labelsize;
@property(nonatomic,assign)float a;
@property(nonatomic,strong)NSArray *labelsArray;

@property(nonatomic,assign)float max;
@end
@implementation FinishedProductLineChart {
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
    _yValueMax = max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    _level = (_yValueMax-_yValueMin)/6;
    
    CGFloat chartCavanHeight = 180*[UIUtils getWindowHeight]/568-25;
    CGFloat levelHeight = chartCavanHeight/6.0;

    for (int i=0; i<7; i++) {
        //y轴label
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(5*[UIUtils getWindowWidth]/320,chartCavanHeight-i*levelHeight,60*[UIUtils getWindowWidth]/320, 20*[UIUtils getWindowHeight]/568)];
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
        num=6;
    _xLabelWidth = myScrollView.frame.size.width/ num;
    //x轴label的
    for (int i=0; i<xLabels.count; i++) {
        
        NSString *labelText = xLabels[i];
        _label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height- UULabelHeight, _xLabelWidth, UULabelHeight)];
        _label.text = labelText;
        _label.font=[UIFont systemFontOfSize:10];
        
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
        NSArray *childAry = _yValues[i];
        
        if (childAry.count==0) {
            return;
        }
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        if (i==0) {
             _chartLine.lineWidth   = 1.8;
        }else{
         _chartLine.lineWidth   = 1.2;
        }
       
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        [myScrollView.layer addSublayer:_chartLine];
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat xPosition = ( _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
        float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
        CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
            [progressline moveToPoint:point];
          
                _pointview = [[UIView alloc]initWithFrame:CGRectMake(4, 5,8, 8)];
                _pointview.layer.masksToBounds = YES;
                _pointview.layer.cornerRadius =4;
                _pointview.center = point;

            if (i==0) {
               
                _pointview.backgroundColor = [UIColor whiteColor];
               [myScrollView addSubview:_pointview];
            }else if (childAry.count==1){
            
                _pointview.backgroundColor = [UIColor redColor];
                [myScrollView addSubview:_pointview];
            }
            
            index += 1;
        }
    
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [[UIColor whiteColor] CGColor];
        }
        
        _chartLine.strokeEnd = 1.0;
    }
}
//返回数组数据
- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
