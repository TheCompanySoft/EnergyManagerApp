//
//  ChangeValueView.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ChangeValueView.h"

@implementation ChangeValueView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.shadowColor=[UIColor grayColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0,-2);
    }
    return self;
}
//获取相应的参数
-(void)getmoveArray:(NSArray*)array {

    
    for (int i=0; i<array.count; i++) {
        UIButton *chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame=AdaptCGRectMake(0, 0+33*i, 190, 33);
        
        chooseBtn.tag=i;
        [chooseBtn setTitleColor:[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        UIView *view=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 33, 190, 1)];
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        view.backgroundColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
        [chooseBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:array[i] forState:UIControlStateNormal];
        [chooseBtn addSubview:view];
        [self addSubview:chooseBtn];
       
    }


}
//我的旅拍按钮被点击
-(void)changeView:(UIButton *)sender
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ChangeValueBuuton:)]) {
        [self.delegate  ChangeValueBuuton:sender];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
