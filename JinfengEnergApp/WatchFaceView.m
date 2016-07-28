//
//  WatchFaceView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "WatchFaceView.h"

@implementation WatchFaceView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //不清楚高度则先添加基本得内部所有子控件
        [self addContentView];
    }
    
    return self;
}

- (void)addContentView{
    UIImage *watchFaceImage = [UIImage imageNamed:@"table"];
    _progress = [[ZFProgressView alloc] initWithFrame:AdaptCGRectMake(5, 0, 140, 140) style:ZFProgressViewStyleNone];
    [self addSubview:_progress];
    _progress.startAngle = 140 *(M_PI /180); //起始135度
    _progress.endAngle =40*(M_PI /180); //终点4度
    
    [_progress setProgressStrokeColor:[UIColor purpleColor]];
    [_progress setBackgroundStrokeColor:[UIColor clearColor]];
    //    中心文字颜色
    [_progress setDigitTintColor:[UIColor whiteColor]];
    
    _tableView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(10, 10, 120, 120)];
    //    _tableView.center = _progress.center;
    _progress.progressLineWidth = (_progress.frame.size.height - _tableView.frame.size.height)/2;
    
    _tableView.image = watchFaceImage;
    _tableView.layer.cornerRadius = _tableView.frame.size.height/2;
    _tableView.layer.masksToBounds = YES;
    [_progress addSubview:_tableView];
    
    _unitsLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(40, 73, 40, 12)];
    _unitsLable.textAlignment = NSTextAlignmentCenter;
    _unitsLable.textColor = [UIColor whiteColor];
    _unitsLable.font = [UIFont systemFontOfSize:10];
    [_tableView addSubview:_unitsLable];
    
    _resultLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(30, 90, 60, 22)];
    _resultLable.textAlignment = NSTextAlignmentCenter;
    _resultLable.textColor = [UIColor whiteColor];
    //    _resultLable.backgroundColor = [UIColor redColor];
    _resultLable.font = [UIFont systemFontOfSize:10];
    _resultLable.numberOfLines = 2;
    
    [_tableView addSubview:_resultLable];
    
    _tableNameLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(30, 130, 90, 30)];
    //    _tableNameLable.backgroundColor = [UIColor blueColor];
    _tableNameLable.textAlignment = NSTextAlignmentCenter;
    _tableNameLable.textColor = [UIColor whiteColor];
    _tableNameLable.font = [UIFont systemFontOfSize:12];
    _tableNameLable.numberOfLines = 2;
    [self addSubview:_tableNameLable];
}

- (void)addRollView{
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
