//
//  DataView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 16/1/29.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "DataView.h"

@implementation DataView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentView];
    }
    return self;
}
//设置内容视图
- (void)setContentView{
    self.directionalLockEnabled = YES; //只能一个方向滑动
    self.pagingEnabled = NO; //是否翻页
    self.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    self.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    self.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    CGSize newSize = CGSizeMake(self.frame.size.width, self.frame.size.height*1.1);
    [self setContentSize:newSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
