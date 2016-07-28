//
//  EnergyConstuteInfo.h
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/5.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnergyConstuteInfo : NSObject
@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*querystime;
@property(nonatomic,strong)NSString*queryetime;
@property(nonatomic,strong)NSString*energyid;
@property(nonatomic,strong)NSString*energyname;
@property(nonatomic,strong)NSString*energyunit;
//能耗值
@property(nonatomic,strong)NSString*energyvalue;
//金额
@property(nonatomic,strong)NSString*energymoney;
//标准能耗
@property(nonatomic,strong)NSString*energysumcoalstandard;
//能耗颜色
@property(nonatomic,strong)NSString*energycolor;
//字典遍历
-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
