//
//  URBSegmentedControl.h
//  URBSegmentedControlDemo
//
//  Created by Nicholas Shipes on 2/1/13.
//  Copyright (c) 2013 Urban10 Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
//分段选择的枚举
enum {
	URBSegmentedControlOrientationHorizontal = 0,
	URBSegmentedControlOrientationVertical
};
typedef NSInteger URBSegmentedControlOrientation;

enum {
	URBSegmentViewLayoutDefault = 0,
	URBSegmentViewLayoutVertical
};
typedef NSInteger URBSegmentViewLayout;

@interface URBSegmentedControl : UISegmentedControl <UIAppearance>

typedef void (^URBSegmentedControlBlock)(NSInteger index, URBSegmentedControl *segmentedControl);

@property (nonatomic) URBSegmentedControlOrientation layoutOrientation;
@property (nonatomic) URBSegmentViewLayout segmentViewLayout;

@property (nonatomic, copy) URBSegmentedControlBlock controlEventBlock;

@property (nonatomic, strong) UIColor *baseColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic) CGFloat cornerRadius;

///----------------------------
/// @name Segment Customization
///----------------------------

@property (nonatomic, strong) UIColor *imageColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedImageColor UI_APPEARANCE_SELECTOR;

- (id)initWithTitles:(NSArray *)titles icons:(NSArray *)icons selecticons:(NSArray *)selecticons;
- (void)setImageColor:(UIColor *)imageColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)setControlEventBlock:(URBSegmentedControlBlock)controlEventBlock;

@end

@interface UIImage (URBSegmentedControl)


- (UIImage *)imageTintedWithColor:(UIColor *)color;

@end