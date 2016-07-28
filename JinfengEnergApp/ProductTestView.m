//
//  ProductTestView.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ProductTestView.h"

@implementation ProductTestView

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
        chooseBtn.frame=AdaptCGRectMake(0, 0+35*i, 190, 32);
        
        chooseBtn.tag=i;
        [chooseBtn setTitleColor:[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        UIView *view=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 31, 190, 0.8)];
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        view.backgroundColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
        [chooseBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:array[i] forState:UIControlStateNormal];
        [chooseBtn addSubview:view];
        [self addSubview:chooseBtn];
        
    }
    
    
}

-(void)changeView:(UIButton *)sender
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ProductTestViewBuuton:)]) {
        [self.delegate  ProductTestViewBuuton:sender];
    }
    
}

@end
