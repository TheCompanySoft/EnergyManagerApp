//
//  Businesstrendinfo.h
//  ProvienCity
//
//  Created by scsys on 15/6/5.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Businesstrendinfo : NSObject
//时间
@property(nonatomic,strong)NSString*dtsdate;
//id
@property(nonatomic,strong)NSString*energyid;
//能源名
@property(nonatomic,strong)NSString*energyname;
@property(nonatomic,strong)NSString*enterid;
@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*subjectid;
//能源种类
@property(nonatomic,strong)NSString*subjecttype;
@property(nonatomic,strong)NSString*varid;
@property(nonatomic,strong)NSString*varname;
@property(nonatomic,strong)NSString*varvalue;

//遍历方法
-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
