//
//  EnddateView.h
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EnddateViewdelegate <NSObject>

//设置按钮点击方法
-(void)enddateView:(NSString*)string;
//取消
-(void)endcancleBtndelegate;

@end
@interface EnddateView : UIView
//代理
@property(nonatomic,assign)id delegate;
@end
