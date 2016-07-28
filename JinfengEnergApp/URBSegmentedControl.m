//
//  URBSegmentedControl.m
//  URBSegmentedControlDemo
//
//  Created by Nicholas Shipes on 2/1/13.
//  Copyright (c) 2013 Urban10 Interactive. All rights reserved.
//

#import "URBSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@interface UIColor (URBSegmentedControl)
- (UIColor *)adjustBrightness:(CGFloat)amount;
@end

@interface URBSegmentView : UIButton
@property (nonatomic, assign) URBSegmentViewLayout viewLayout;
@property (nonatomic, assign) CGFloat cornerRadius;
- (void)setTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state;
- (void)updateBackgrounds;
@end

@interface URBSegmentedControl ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic) UIEdgeInsets segmentEdgeInsets;
@property (nonatomic, strong) NSDictionary *segmentTextAttributes;
- (void)layoutSegments;
- (void)handleSelect:(URBSegmentView *)segmentView;
- (NSInteger)firstEnabledSegmentIndexNearIndex:(NSUInteger)index;
- (UIImage *)defaultBackgroundImage;
@end

static CGSize const kURBDefaultSize = {300.0f, 44.0f};

@implementation URBSegmentedControl {
    NSInteger _selectedSegmentIndex;
    NSInteger _lastSelectedSegmentIndex;
}



- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _selectedSegmentIndex = -1;
        _lastSelectedSegmentIndex = -1;
        _items = [NSMutableArray new];
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.frame = AdaptCGRectMake(0.0, 0.0, kURBDefaultSize.width, kURBDefaultSize.height);
        //        图片颜色
        self.imageColor = [UIColor whiteColor];
        self.selectedImageColor = [UIColor colorWithRed:48/255.0 green:131/255.0 blue:25/255.0 alpha:1];
        self.segmentEdgeInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
        
        // base styles
        self.baseColor = [UIColor clearColor];
        self.strokeColor = [UIColor clearColor];
        self.cornerRadius = 4.0f;
        
        // layout
        
        // base image view
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"green_bg"];
        _backgroundView.frame = self.frame;
        [self insertSubview:_backgroundView atIndex:0];
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles icons:(NSArray *)icons selecticons:(NSArray *)selecticons{
    self = [self init];
    if (self) {
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [self insertSegmentWithTitle:title image:[icons objectAtIndex:idx] selectimage:[selecticons objectAtIndex:idx] atIndex:idx animated:YES];
        }];
    }
    return self;
}

- (void)insertSegmentWithTitle:(NSString *)title image:(UIImage *)image selectimage:(UIImage *)selectimage atIndex:(NSUInteger)segment  animated:(BOOL)animated {
#pragma mark 背景
    URBSegmentView *segmentView = [URBSegmentView new];
    [segmentView setTitle:title forState:UIControlStateNormal];
    [segmentView setImage:[image imageTintedWithColor:self.imageColor] forState:UIControlStateNormal];
    [segmentView setImage:[selectimage imageTintedWithColor:self.selectedImageColor] forState:UIControlStateSelected];
    [segmentView addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    // style the segment
    segmentView.viewLayout = self.segmentViewLayout;
    if (self.segmentTextAttributes) {
        [segmentView setTextAttributes:self.segmentTextAttributes forState:UIControlStateNormal];
    }
    
    // set custom styles if defined
    segmentView.cornerRadius = self.cornerRadius;
    
    CGRect segmentRect = CGRectMake(0, 0, MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)), MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)));
    segmentView.frame = CGRectInset(segmentRect, self.segmentEdgeInsets.top, self.segmentEdgeInsets.left);
    
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments), 0);
    if (index < self.items.count) {
        [self.items insertObject:segmentView atIndex:index];
    }
    else {
        [self.items addObject:segmentView];
    }
    [self addSubview:segmentView];
    
    if (self.selectedSegmentIndex >= index) {
        self.selectedSegmentIndex++;
    }
    _lastSelectedSegmentIndex = self.selectedSegmentIndex;
    
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutSegments];
        }];
    }
    else {
        [self setNeedsLayout];
    }
}

#pragma mark - UIKit API Overrides
- (NSUInteger)numberOfSegments {
    return self.items.count;
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment {
    [self segmentAtIndex:segment].enabled = enabled;
}

- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)segment {
    return [self segmentAtIndex:segment].enabled;
}
//
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        NSParameterAssert(selectedSegmentIndex < (NSInteger)self.items.count);
        
        // deselect current segment if selected
        if (_selectedSegmentIndex >= 0)
            ((URBSegmentView *)[self segmentAtIndex:_selectedSegmentIndex]).selected = NO;
        
        ((URBSegmentView *)[self segmentAtIndex:selectedSegmentIndex]).selected = YES;
        _lastSelectedSegmentIndex = _selectedSegmentIndex;
        _selectedSegmentIndex = selectedSegmentIndex;
        
        [self setNeedsLayout];
    }
}

- (NSInteger)selectedSegmentIndex {
    return _selectedSegmentIndex;
}

#pragma mark - Customization
- (void)setImageColor:(UIColor *)imageColor forState:(UIControlState)state {
    [self.items enumerateObjectsUsingBlock:^(URBSegmentView *segmentView, NSUInteger idx, BOOL *stop) {
        
        UIImage *image = [segmentView imageForState:state];
        UIColor *color = (state == UIControlStateSelected) ? self.selectedImageColor : self.imageColor;
        
        [segmentView setImage:[image imageTintedWithColor:color] forState:state];
        
    }];
}

#pragma mark - Background Images


#pragma mark - Private
- (URBSegmentView *)segmentAtIndex:(NSUInteger)index {
    NSParameterAssert(index >= 0 && index < self.items.count);
    return [self.items objectAtIndex:index];
}

- (void)handleSelect:(URBSegmentView *)segmentView {
    NSUInteger index = [self.items indexOfObject:segmentView];
    if (index != NSNotFound && index != self.selectedSegmentIndex) {
        self.selectedSegmentIndex = index;
        [self setNeedsLayout];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        if (self.controlEventBlock) {
            self.controlEventBlock(self.selectedSegmentIndex, self);
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    if (!self.backgroundView.image) {
        self.backgroundView.image = [self defaultBackgroundImage];
    }
    [self layoutSegments];
}

- (void)layoutSegments {
    if (self.items.count == 0) return;
    
    // calculate width of each segment based on number of items and total available width
    CGRect segmentRect = CGRectInset(self.bounds, self.segmentEdgeInsets.top, self.segmentEdgeInsets.left);
    CGSize totalSize = segmentRect.size;
    CGSize segmentSize = (self.layoutOrientation == URBSegmentedControlOrientationVertical) ? CGSizeMake(totalSize.width, totalSize.height / self.items.count) : CGSizeMake(totalSize.width / self.items.count, totalSize.height);
    
    [self.items enumerateObjectsUsingBlock:^(URBSegmentView *item, NSUInteger idx, BOOL *stop) {
        if (self.layoutOrientation == URBSegmentedControlOrientationVertical) {
            item.frame = CGRectMake(CGRectGetMinX(segmentRect), CGRectGetMinY(segmentRect) + segmentSize.height * idx, segmentSize.width, segmentSize.height);
        }
        else {
            item.frame = CGRectMake(CGRectGetMinX(segmentRect) + segmentSize.width * idx, CGRectGetMinY(segmentRect), segmentSize.width, segmentSize.height);
        }
        [item setNeedsLayout];
    }];
}

@end


#pragma mark - URBSegmentView

@implementation URBSegmentView {
    BOOL _hasDrawnImages;
    BOOL _adjustInsetsForSize;
}

+ (void)initialize {
    [super initialize];
    
    URBSegmentView *appearance = [self appearance];
#pragma mark   文字颜色
    [appearance setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appearance setTitleColor:[UIColor  colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateSelected];
}

+ (URBSegmentView *)new {
    return [self.class buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.userInteractionEnabled = YES;
        //        self.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.clipsToBounds = NO;
        self.adjustsImageWhenHighlighted = NO;
        
        self.viewLayout = URBSegmentViewLayoutDefault;
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        icon
        _hasDrawnImages = NO;
        _adjustInsetsForSize = YES;
    }
    return self;
}

- (void)setViewLayout:(URBSegmentViewLayout)viewLayout {
    _viewLayout = viewLayout;
#pragma mark    icon布局
    if (viewLayout == URBSegmentViewLayoutDefault) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        self.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 20.0f, 5.0f, 5.0f);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return;
    }
    if (!_hasDrawnImages) {
        _hasDrawnImages = YES;
        [self updateBackgrounds];
    }
    
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
    
    if (self.viewLayout == URBSegmentViewLayoutDefault) {
#pragma mark        字符靠左
        if (self.titleLabel.text.length > 0 && self.imageView.image) {
            CGRect imageRect = frame;
            imageRect.size.width = imageRect.size.height;
            self.imageView.frame = imageRect;
            
            CGRect titleFrame = UIEdgeInsetsInsetRect(frame, self.titleEdgeInsets);
            titleFrame.origin.x = CGRectGetMaxX(self.imageView.frame);
            titleFrame.size.width = (CGRectGetWidth(frame) - CGRectGetMinX(titleFrame))*1.2;
            self.titleLabel.frame = titleFrame;
        }
    }
}

#pragma mark - Background Images

- (void)updateBackgrounds {
    [self setBackgroundImage:[self normalBackgroundImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[self selectedBackgroundImage] forState:UIControlStateSelected];
}

- (UIImage *)normalBackgroundImage {
    return nil;
}

- (UIImage *)selectedBackgroundImage {
   // CGSize size = self.bounds.size;
    CGRect frame = self.frame;
    
#pragma mark    选中图片
    UIImage *image = [UIImage imageNamed:@"perbac"];
    UIGraphicsEndImageContext();
    
    CGFloat topCap = CGRectGetMidY(frame);
    CGFloat leftCap = CGRectGetMidX(frame);
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(topCap, leftCap, topCap, leftCap)];
}

@end


#pragma mark - UIImage Category

@implementation UIImage (URBSegmentedControl)

/**
 UIImage tint category methods originally developed by Matt Gemmell and released under the BSD License: http://mattgemmell.com/license/
 https://github.com/mattgemmell/MGImageUtilities
 */
//
- (UIImage *)imageTintedWithColor:(UIColor *)color {
    if (color) {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f);
        
        CGRect rect = CGRectZero;
        rect.size = [self size];
        
        [color set];
        UIRectFill(rect);
        
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return self;
}

@end

