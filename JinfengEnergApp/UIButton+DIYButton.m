//
//  UIButton+DIYButton.m
//  JinfengEnergApp
//
//  Created by   陈黔 on 16/3/2.
//  Copyright © 2016年 BlackChen. All rights reserved.
//

#import "UIButton+DIYButton.h"
#import <objc/runtime.h>

static void *idStringKey = &idStringKey;

@implementation UIButton (DIYButton)
@dynamic idString;

- (NSString *)idString{
    return objc_getAssociatedObject(self, idStringKey);
}

- (void)setIdString:(NSString *)idString{
    objc_setAssociatedObject(self, idStringKey, idString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
