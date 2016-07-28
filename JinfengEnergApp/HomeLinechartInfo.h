//
//  HomeLinechartInfo.h
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/6.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeLinechartInfo : NSObject
//能源的颜色
@property(nonatomic,strong)NSString*energyColor;
//能源的种类
@property(nonatomic,strong)NSString*energyType;
//对应的数据
@property(nonatomic,strong)NSArray*energyList;
//实例方法
-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
