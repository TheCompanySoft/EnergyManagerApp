//
//  Myprotocol.h
//  练习1
//
//  Created by scsys on 15/5/29.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Myprotocol <NSObject>
@optional
//协议方法

-(void)paddArray:(NSArray*)arr;
//产品能耗数组
-(void)productArray:(NSArray*)arr ;
//企业能耗数组
-(void)businessArray:(NSArray*)array;
//区域能耗数组
-(void)areaArray:(NSArray*)array;
//编码数据组
-(void)businecode:(NSArray*)array;
@end
