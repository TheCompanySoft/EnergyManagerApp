//
//  ChartListCell.m
//  biaodemo
//
//  Created by huake on 15/12/13.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "ChartListCell.h"
#import "UIUtils.h"
@implementation ChartListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=NO;
    }
    return self;
}
//获取表的参数
-(void)getarray:(NSArray*)array and:(NSInteger)row and:(NSInteger)count{
//    for (int i=0; i<count; i++) {
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/count*(i+1), 0, 1, 31)];
//        view.backgroundColor=[UIColor whiteColor];
//        [self addSubview:view];
//    }

    for (int i=0; i<count; i++){
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/count*i+0.5*i,1, [UIUtils getWindowWidth]/count-0.5, 30*[UIUtils getWindowHeight]/568)];
        lable.backgroundColor=[UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
        lable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0/255.0 alpha:1];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:14];
        lable.text=array[row][i];
        [self addSubview:lable];
    }
    
}

@end
