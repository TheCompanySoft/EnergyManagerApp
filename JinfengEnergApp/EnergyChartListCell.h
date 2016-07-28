//
//  ChartListCell.h
//  biaodemo
//
//  Created by huake on 15/12/13.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnergyConstuteInfo.h"
@interface EnergyChartListCell : UITableViewCell
//对象的调用
-(void)getareaEnrgeyInfo:(EnergyConstuteInfo*)areaInfo;
@end
