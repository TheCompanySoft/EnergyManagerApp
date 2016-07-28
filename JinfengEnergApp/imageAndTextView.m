//
//  imageAndTextView.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/9.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "imageAndTextView.h"
@interface imageAndTextView ()

@end

@implementation imageAndTextView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
    
}
- (void)addContentView{
    self.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = AdaptCGRectMake(10, 10, 12, 12);
    [self addSubview:_imageView];
    
    _lable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(30, 5, 100, 24)];
    _lable.font=[UIFont systemFontOfSize:13];
    _lable.textColor = [UIColor whiteColor];
    [self addSubview:_lable];
}

- (void)setViewWithimage:(UIImage *)image andtext:(NSString *)string{
    _lable.text = string;
    _imageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
