//
//  ChangeWeekView.h
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeweekViewdelegate <NSObject>

//设置按钮点击方法
-(void)ChangeweekBuuton:(UIButton*)btn;


@end

@interface ChangeWeekView : UIView
@property(nonatomic,assign)id delegate;
//获取相应的参数
-(void)getmoveArray:(NSArray*)array;
@end
