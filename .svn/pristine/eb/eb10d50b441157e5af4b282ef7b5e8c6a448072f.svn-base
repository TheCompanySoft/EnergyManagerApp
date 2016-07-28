//
//  personCell.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "personCell.h"

@interface personCell()
{
    BOOL isSelecedb;
}

@end

@implementation personCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //不清楚高度则先添加基本得内部所有子控件
        [self setData];
    }
    
    return self;
}

#pragma  添加基本的内部控件
-(void)setData
{    UIView *lineView;

    for (int i = 0; i <2; i ++) {
         lineView = [[UIView alloc]initWithFrame:AdaptCGRectMake(10, 44*i, 320-20, 1)];
    }
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
//    头像
    _icon  = [[UIImageView alloc] initWithFrame:AdaptCGRectMake(20, 15, 13, 14)];
    [self addSubview:_icon];
    //title
    _title = [[UILabel alloc] initWithFrame:AdaptCGRectMake(50, 10, 150, 24)];
    [self addSubview: _title];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = AdaptCGRectMake(290, 17, 15, 10);
     isSelecedb = YES;
    [_button setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];

//    [_button addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
   }

- (void)changeFrame:(UIButton *)sender{
    if (isSelecedb != YES) {
        isSelecedb = YES;
        [_button setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    }else{
        isSelecedb = NO;
        [_button setImage:[UIImage imageNamed:@"bottom_arrow_hiddeen"] forState:UIControlStateNormal];

    }
}

- (void)awakeFromNib {
    // Initialization code
}



@end
