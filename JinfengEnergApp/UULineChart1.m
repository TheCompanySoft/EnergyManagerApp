//
//  UULineChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "UULineChart1.h"
#import "UUColor.h"
#import "UUChartLabel.h"

#import "UIUtils.h"
#import "Header.h"
#import "UIUtils.h"


#define UULabelHeight    10

@interface UULineChart1 ()<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UUChartLabel * _label;
    UIView *_pointview;
    UIView *_lineView;
  
}
@property(nonatomic,assign)float labelsize;
@property(nonatomic,assign)float a;
@property(nonatomic,strong)NSArray *labelsArray;

@property(nonatomic,assign)float max;
@end
@implementation UULineChart1 {
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
        _lineView = [[UIView alloc] initWithFrame:AdaptCGRectMake(0,0,320/6,568/2-50)] ;

        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(_lineView.frame.size.width/2, 5, 1*[UIUtils getWindowWidth]/320, 165*[UIUtils getWindowHeight]/568)];
        view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
        [_lineView addSubview:view];
        _lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:_lineView];
    }
    return self;
}
//设置y值
-(void)setYValues:(NSArray *)yValues
{
        _yValues = yValues ;
        [self setYLabels:yValues];

    }
//滚动传值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point=scrollView.contentOffset;
    
    CGRect frame = _lineView.frame;
    
    _a=5*_xLabelWidth*point.x/(_max-[UIUtils getWindowWidth]);
    
    
   // double gv=4*_xLabelWidth/((_max-_xLabelWidth)/_xLabelWidth);
    
  //  int index=_a/gv;
    if (_yValues.count==2) {
        
       
    }
    
    
  
    
    frame.origin.x=_a;
    _lineView.frame=frame;
    _lineView.backgroundColor=[UIColor clearColor];
    [self addSubview:_lineView];
    if (point.x<0) {
        [self addSubview:_lineView];
    }
    
    
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
    
    _level = (_yValueMax-_yValueMin)/6.0;
    
    CGFloat chartCavanHeight = 175*[UIUtils getWindowHeight]/568-25;
    CGFloat levelHeight = chartCavanHeight/6.0;
    
    for (int i=0; i<7; i++) {
        //y轴label
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(5*[UIUtils getWindowWidth]/320,chartCavanHeight-i*levelHeight,25*[UIUtils getWindowWidth]/320, 20*[UIUtils getWindowHeight]/568)];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:11];
        label.backgroundColor=[UIColor clearColor];
      label.text = [NSString stringWithFormat:@"%d",(int)(_level * i+_yValueMin)];
     
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
        NSArray *childAry = _yValues[i];
       
        if (childAry.count==0) {
            return;
        }
      
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[_colors objectAtIndex:i] CGColor];
        _chartLine.lineWidth   = 1.8;
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
            BOOL isShowMaxAndMinPoint = YES;
            [progressline moveToPoint:point];
            if (index!=2) {
                _pointview = [[UIView alloc]initWithFrame:CGRectMake(4, 5,8, 8)];
                _pointview.layer.masksToBounds = YES;
                _pointview.layer.cornerRadius =4;
                
                _pointview.center = point;
                _pointview.layer.borderColor = [UIColor whiteColor].CGColor;
                if (isShowMaxAndMinPoint) {
                    _pointview.backgroundColor = [_colors objectAtIndex:i];
                }else{
                    _pointview.backgroundColor = [_colors objectAtIndex:i];
                }
                
                [myScrollView addSubview:_pointview];
                
            }else{
                _pointview = [[UIView alloc]initWithFrame:CGRectMake(4, 5,14, 14)];
                _pointview.layer.masksToBounds = YES;
                _pointview.layer.cornerRadius =7;
                _pointview.layer.borderWidth=1;
                _pointview.center = point;
                _pointview.layer.borderColor = [UIColor whiteColor].CGColor;
                if (isShowMaxAndMinPoint) {
                    _pointview.backgroundColor = [_colors objectAtIndex:i];
                }else{
                    _pointview.backgroundColor = [UIColor greenColor];
                }
                
                [myScrollView addSubview:_pointview];
            }
           
            index += 1;
        }
    
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:0] CGColor]) {
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
