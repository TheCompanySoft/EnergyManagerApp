//
//  NSString+Util.m
//  Travel
//
//  Created by mickel on 9/5/14.
//  Copyright (c) 2014 mickel. All rights reserved.
//

#import "NSString+Util.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)
- (NSString *)md5HexDigest:(NSString *)stone
{
    const char *original_str = [stone UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableArray *byte = [NSMutableArray array];
    for (int i = 0; i < 16; i++)
        [byte addObject:@(result[i])];
    NSData *da=[NSData dataWithBytes:result length:byte.count];
    NSString*baseStr=[GTMBase64 encodeBase64Data:da];
    return baseStr;
    
}

@end
