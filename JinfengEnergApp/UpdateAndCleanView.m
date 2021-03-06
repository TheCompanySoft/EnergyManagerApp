//
//  UpdateAndCleanView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/16.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "UpdateAndCleanView.h"

@implementation UpdateAndCleanView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
    
}
    //添加内容视图
- (void)addContentView{
    _updateAndCleanLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(50, 5, 190, 25)];
    _updateAndCleanLable.font = [UIFont systemFontOfSize:14];
    _updateAndCleanLable.textColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    [self addSubview:_updateAndCleanLable];
    
    self.updateAndCleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateAndCleanButton.frame = AdaptCGRectMake(240, 5, 60, 25);
    _updateAndCleanButton.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    _updateAndCleanButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_updateAndCleanButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
