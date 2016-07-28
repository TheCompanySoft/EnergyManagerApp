//
//  CalculateFileSize.m
//  JinfengEnergApp
//
//  Created by BlackChen on 16/1/15.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "CalculateFileSize.h"

@implementation CalculateFileSize

//单利
+ (instancetype)defaultCalculateFileSize
{
    static CalculateFileSize *calculateFileSize =nil;
    @synchronized(self)  {
        if (!calculateFileSize) {
            calculateFileSize   =  [[self alloc]init];;
        }
    }
    return calculateFileSize;
}

//计算单个文件大小返回值是M
- (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        // 返回值是字节 B K M
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录大小
- (float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 计算单个文件大小
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        // folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
//清理缓存文件

//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
- (void)clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    // SDImageCache 自带缓存
    //[[SDImageCache sharedImageCache] cleanDisk];
}
@end