

//
//  ProductInfo.m
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/5.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "ProductInfo.h"

@implementation ProductInfo
-(id)initWithDictionary:(NSDictionary*)dictionary{
    if ([super init]) {
       
        
     
        self.dtsdate=[dictionary objectForKey:@"dtsdate"];
        self.energyid=[dictionary objectForKey:@"energyid"];
        self.energyname=[dictionary objectForKey:@"energyname"];
        self.enterid=[dictionary objectForKey:@"enterid"];
        self.entername=[dictionary objectForKey:@"entername"];
        self.idd=[dictionary objectForKey:@"id"];
        self.outenergyid=[dictionary objectForKey:@"outenergyid"];
        self.outenergyname=[dictionary objectForKey:@"outenergyname"];
        self.subjectid=[dictionary objectForKey:@"subjectid"];
        self.subjecttype=[dictionary objectForKey:@"subjecttype"];
        self.varid=[dictionary objectForKey:@"varid"];
        self.varname=[dictionary objectForKey:@"varname"];
        self.varvalue=[dictionary objectForKey:@"varvalue"];
        
    }
    return self;
    
}

@end
