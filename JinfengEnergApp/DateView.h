//
//  DateView.h
//  UIDataPickView
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 郑磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DateViewdelegate <NSObject>

//设置按钮点击方法
-(void)dateView:(NSString*)string;

//取消
-(void)cancelBtnDelegate;


@end
@interface DateView : UIView
//代理方法
@property(nonatomic,assign)id delegate;
@end
