//
//  SettingViewController.h
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"

@interface SettingViewController : UIViewController<TQTableViewDelegate,TQTableViewDataSource>

@property (nonatomic, strong) TQMultistageTableView *mTableView;
@property (nonatomic, copy)NSString *cacheData;
@property (nonatomic, copy)NSString *acountName;
@property (nonatomic, strong) UILabel *introduceTextView;

@end
