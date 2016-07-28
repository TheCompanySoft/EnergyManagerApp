//
//  MyView.h
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendanalysisView : UIView
@property(nonatomic,strong)NSArray*allarray;
//数组的参数的传递
-(void)getAllArray:(NSArray*)allArray andDate:(NSArray*)arrray andColors:(NSArray*)colors;
@end
