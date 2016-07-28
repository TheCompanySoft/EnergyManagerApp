//
//  CalculateFileSize.h
//  JinfengEnergApp
//
//  Created by BlackChen on 16/1/15.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateFileSize :NSObject //单利
//类方法
+ (instancetype)defaultCalculateFileSize;

// 计算单个文件大小
- (float)fileSizeAtPath:(NSString*)path;
// 计算目录大小
- (float)folderSizeAtPath:(NSString*)path;
// 清除文件按
- (void)clearCache:(NSString *)path;

@end
