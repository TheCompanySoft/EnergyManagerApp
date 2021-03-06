//
//  ChartListCell.m
//  biaodemo
//
//  Created by huake on 15/12/13.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "ProductListCell.h"
#import "ProductInfo.h"
@interface ProductListCell ()
{
    //表中cell所对应的label
    UILabel *lable;
    UILabel *lable1;
    UILabel *lable2;
    UILabel *lable3;
}
@end

@implementation ProductListCell
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
//获取表的参数
-(void)addcontentView{
    
    lable=[[UILabel alloc]initWithFrame:CGRectMake(0,1, [UIUtils getWindowWidth]/4-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable];
    
    lable1=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/4*1+0.5*1,1, [UIUtils getWindowWidth]/4-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable1.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable1.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable1.textAlignment=NSTextAlignmentCenter;
    lable1.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable1];
    lable2=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/4*2+0.5*2,1, [UIUtils getWindowWidth]/4-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable2.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable2.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable2.textAlignment=NSTextAlignmentCenter;
    lable2.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable2];
    lable3=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/4*3+0.5*3,1, [UIUtils getWindowWidth]/4-0.5, 30*[UIUtils getWindowHeight]/568)];
    lable3.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
    lable3.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
    lable3.textAlignment=NSTextAlignmentCenter;
    lable3.font=[UIFont systemFontOfSize:11];
    [self addSubview:lable3];
}
//获取数据
-(void)getspecificArray:(NSArray *)specificArray and:(NSArray *)standardSpecificArray and:(NSArray *)personArray and:(NSArray *)dateArray and:(NSInteger)row{
         lable.text=dateArray[row];
        lable1.text=specificArray[row];
        lable2.text=standardSpecificArray[row];
        lable3.text=personArray[row];
   
}
@end
