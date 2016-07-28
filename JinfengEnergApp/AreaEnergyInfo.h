//
//  AreaEnergyInfo.h
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/29.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaEnergyInfo : NSObject
//金额
@property(nonatomic,strong)NSString*energymoney;
//标准能耗
@property(nonatomic,strong)NSString*energysumcoalstandard;
//id
@property(nonatomic,strong)NSString*idd;
//时间
@property(nonatomic,strong)NSString*queryetime;
@property(nonatomic,strong)NSString*querystime;
@property(nonatomic,strong)NSString*regionalid;
//名称
@property(nonatomic,strong)NSString*regionalname;
//数量
@property(nonatomic,strong)NSString*sumamount;
@property(nonatomic,strong)NSString*entercount;


-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
