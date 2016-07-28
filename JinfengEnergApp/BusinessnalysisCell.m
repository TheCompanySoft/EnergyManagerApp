//
//  BusinessnalysisCell.m
//  JinfengEnergApp
//
//  Created by HKsoft on 16/1/5.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "BusinessnalysisCell.h"
#import "Header.h"
#import "UIUtils.h"
@interface BusinessnalysisCell ()
{
    
    UILabel *lable;//能源
    UILabel *lable1;//数量
    UILabel *lable2;//金额
    NSArray*allValueArray;//所有数量
    NSArray*allpriceArray;//所有价格
    NSInteger a;//行
}
@end
@implementation BusinessnalysisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=NO;
        [self addcontentView];
    }
    return self;
}
 //添加内容视图
-(void)addcontentView{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi:) name:@"1" object:nil];
    lable=[[UILabel alloc]initWithFrame:CGRectMake(0,1, [UIUtils getWindowWidth]/3-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable];
    
    lable1=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/3*1+0.5*1,1, [UIUtils getWindowWidth]/3-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable1.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable1.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable1.textAlignment=NSTextAlignmentCenter;
    lable1.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable1];
    lable2=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/3*2+0.5*2,1, [UIUtils getWindowWidth]/3-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable2.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable2.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable2.textAlignment=NSTextAlignmentCenter;
    lable2.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable2];
    
}
//利用通知将数组的索引传给数组获取对应的参数
-(void)sayHi:(NSNotification *)noti
{
    
    int index=[noti.object intValue];
    
   
    if (lable1.text!=nil) {
        lable1.text=nil;
        lable1.text=allValueArray[a][index];
    }
    if (lable2.text!=nil) {
        lable2.text=nil;
  
        lable2.text=allpriceArray[a][index];
        
    }
  
    
}
//获取数据
-(void)getenergytypeArray:(NSArray*)typeArray and:(NSArray*)countArray and:(NSArray*)priceArray and:(NSInteger)row{
    allValueArray=countArray;
   allpriceArray=priceArray;
    lable.text=typeArray[row];
    lable1.text=countArray[row][0];
     lable2.text=priceArray[row][0];
    a=row;
}
@end
