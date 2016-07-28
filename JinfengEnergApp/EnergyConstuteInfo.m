//
//  EnergyConstuteInfo.m
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/5.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "EnergyConstuteInfo.h"

@implementation EnergyConstuteInfo
//方法的遍历
-(id)initWithDictionary:(NSDictionary*)dictionary{
    if ([super init]) {
        
        self.idd=[dictionary objectForKey:@"id"];
        self.querystime=[dictionary objectForKey:@"querystime"];
        self.queryetime=[dictionary objectForKey:@"queryetime"];
        self.energyid=[dictionary objectForKey:@"energyid"];
        self.energyname=[dictionary objectForKey:@"energyname"];
        self.energyunit=[dictionary objectForKey:@"energyunit"];
        self.energyvalue=[dictionary objectForKey:@"energyvalue"];
        self.energymoney=[dictionary objectForKey:@"energymoney"];
        
        self.energysumcoalstandard=[dictionary objectForKey:@"energysumcoalstandard"];
        self.energycolor=[dictionary objectForKey:@"energycolor"];


    }
    return self;
    
}

@end
