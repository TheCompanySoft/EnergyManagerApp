//
//  warningViewcellTableViewCell.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "warningViewcellTableViewCell.h"

@interface warningViewcellTableViewCell ()
@end

@implementation warningViewcellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setContent];
    }
    return self;
}
//内容视图
- (void)setContent{
    _icon = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(12, 2, 8, 8)];
    _icon.image = [UIImage imageNamed:@"warning_yellow"];
    [self addSubview:_icon];
    
    _title = [[UILabel alloc]initWithFrame:AdaptCGRectMake(25, 2, 100, 11)];
    _title.font = [UIFont systemFontOfSize:11];
    _title.textColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    [self addSubview:_title];
    
    _news = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(200, 3, 15, 8)];
    [self addSubview:_news];
    _time = [[UILabel alloc]initWithFrame:AdaptCGRectMake(25, 14, 120, 9)];
    _time.font = [UIFont systemFontOfSize:9];
    _time.textColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    [self addSubview:_time];
    _details = [[UILabel alloc]initWithFrame:AdaptCGRectMake(25, 23, 190, 27)];
    _details.font = [UIFont systemFontOfSize:12];
    _details.textAlignment = NSTextAlignmentLeft;
    _details.numberOfLines = 2;
    _details.textColor = [UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0 alpha:1];
    [self addSubview:_details];
    _line = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(10, self.frame.origin.y, 205, 1)];
    _line.tag = 100;
    _line.backgroundColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
    [self addSubview:_line];
    
    
}

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
