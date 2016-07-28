//
//  PersonView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/11.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "PersonView.h"

@implementation PersonView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
    
}

- (void)addContentView{
    //    姓名/账户
   _acountLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(50, 5, 220, 25)];
    _acountLable.font = [UIFont systemFontOfSize:14];
    _acountLable.textColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    _acountLable.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self addSubview:_acountLable];
    
    
    _unsubscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _unsubscribeButton.frame = AdaptCGRectMake(50, 44, 220, 25);
    _unsubscribeButton.backgroundColor = [UIColor lightGrayColor];
    [_unsubscribeButton setTitle:@"注销当前账户" forState:UIControlStateNormal];
    _unsubscribeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _unsubscribeButton.backgroundColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
    
    [self addSubview:_unsubscribeButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
