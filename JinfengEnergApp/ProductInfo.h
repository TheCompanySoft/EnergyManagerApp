//
//  ProductInfo.h
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/5.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject
//对接口数据的解析封装成相应的对象
@property(nonatomic,strong)NSString*dtsdate;
@property(nonatomic,strong)NSString*energyid;
@property(nonatomic,strong)NSString*energyname;
@property(nonatomic,strong)NSString*enterid;
@property(nonatomic,strong)NSString*entername;
@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*outenergyid;
@property(nonatomic,strong)NSString*outenergyname;
@property(nonatomic,strong)NSString*subjectid;
@property(nonatomic,strong)NSString*subjecttype;
@property(nonatomic,strong)NSString*varid;
@property(nonatomic,strong)NSString*varname;
@property(nonatomic,strong)NSString*varvalue;
//遍历初始化
-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
