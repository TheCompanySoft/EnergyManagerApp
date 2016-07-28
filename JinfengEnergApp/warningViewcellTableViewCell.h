//
//  warningViewcellTableViewCell.h
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/17.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface warningViewcellTableViewCell : UITableViewCell

//图标
@property (strong, nonatomic) UIImageView *icon;
//标题
@property (strong, nonatomic) UILabel *title;
//new
@property (strong, nonatomic) UIImageView *news;
//时间
@property (strong, nonatomic) UILabel *time;
//详细
@property (strong, nonatomic) UILabel *details;
//线
@property (strong, nonatomic) UIImageView *line;
//隐藏与显示
@property (assign, nonatomic) BOOL isHidden;


@end
