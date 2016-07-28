//
//  TWRDataSet.m
//  ChartJS
//
//  Created by Michelangelo Chasseur on 21/04/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRDataSet.h"

@implementation TWRDataSet

- (instancetype)initWithDataPoints:(NSArray *)dataPoints {
    // Default color: light gray
    UIColor *fillColor = [UIColor redColor];
    UIColor *strokeColor = [UIColor blueColor];
    UIColor *pointColor = [UIColor yellowColor];
    UIColor *pointStrokeColor = [UIColor purpleColor];
    self = [self initWithDataPoints:dataPoints fillColor:fillColor strokeColor:strokeColor pointColor:pointColor pointStrokeColor:pointStrokeColor];

    return self;
}

- (instancetype)initWithDataPoints:(NSArray *)dataPoints
                         fillColor:(UIColor *)fillColor
                       strokeColor:(UIColor *)strokeColor {
    UIColor *pointColor = strokeColor;
    UIColor *pointStrokeColor = strokeColor;
    self = [self initWithDataPoints:dataPoints fillColor:fillColor strokeColor:strokeColor pointColor:pointColor pointStrokeColor:pointStrokeColor];
    
    return self;
}

- (instancetype)initWithDataPoints:(NSArray *)dataPoints
                         fillColor:(UIColor *)fillColor
                       strokeColor:(UIColor *)strokeColor
                        pointColor:(UIColor *)pointColor
                  pointStrokeColor:(UIColor *)pointStrokeColor {
    self = [super init];
    if (self) {
        _dataPoints = dataPoints.mutableCopy;
        _fillColor = fillColor;
        _strokeColor = strokeColor;
        _pointColor = pointColor;
        _pointStrokeColor = pointStrokeColor;
    }
    return self;
}

@end
