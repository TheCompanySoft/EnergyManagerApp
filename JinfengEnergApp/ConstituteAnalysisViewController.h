//
//  ChoseOfAnalysisViewController3.h
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Myprotocol.h"
@interface ConstituteAnalysisViewController : UIViewController
//代理方法
@property(nonatomic,assign)id<Myprotocol>delegat;
@end
