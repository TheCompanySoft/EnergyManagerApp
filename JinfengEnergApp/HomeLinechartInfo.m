//
//  HomeLinechartInfo.m
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/6.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "HomeLinechartInfo.h"

@implementation HomeLinechartInfo
-(id)initWithDictionary:(NSDictionary*)dictionary{
    if ([super init]) {
        
        self.energyColor=[dictionary objectForKey:@"energyColor"];
        self.energyType=[dictionary objectForKey:@"energyType"];
        self.energyList=[dictionary objectForKey:@"energyList"];
        
    }
    return self;
    
}

@end
