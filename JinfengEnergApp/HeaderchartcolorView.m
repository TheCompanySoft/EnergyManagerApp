//
//  HeaderchartcolorView.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/14.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "HeaderchartcolorView.h"
#import "Header.h"
@interface HeaderchartcolorView ()
{
    //能源
    NSArray*_nameArray;
    //能源对应的数组
    NSMutableArray*_colorsArray;
}
@end
@implementation HeaderchartcolorView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _colorsArray=[NSMutableArray array];
        //添加内容视图
        //[self addContentView];
    }
    return self;
}

-(void)getArray:(NSArray *)nameArray and:(NSArray *)colors{

  // _colorsArray = colors;
    
    _nameArray= nameArray;
    for (int i = 0; i < nameArray.count; i ++) {
       
        UIView*  colorView = [[UIView alloc]initWithFrame:AdaptCGRectMake(20 + i*58, 4,8, 8)];
        colorView.layer.cornerRadius=4;
        UIColor *cilor=[self stringTOColor:colors[i]];
        [_colorsArray addObject:cilor];
        colorView.backgroundColor=cilor;
        [self addSubview:colorView];
        UILabel *lable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(32 + i*58, 0,60, 15)];
        lable.text = _nameArray[i];
        lable.font = [UIFont systemFontOfSize:11];
        lable.textColor = [UIColor whiteColor];
        
        [self addSubview:lable];

    }

}
//将字符串转换为颜色
- (UIColor *)stringTOColor:(NSString *)str
{
    
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
