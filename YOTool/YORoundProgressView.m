//
//  YORoundProgressView.m
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

#import "YORoundProgressView.h"

CG_INLINE CGFloat TO_RADIUS(CGFloat a)
{
    return a / 180.0 * M_PI;
}

@implementation YORoundProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.progress = 0.0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineBackColor:(UIColor *)lineBackColor lineColor:(UIColor *)lineColor backColor:(nonnull UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backColor;
        self.lineWidth = lineWidth;
        self.lineBackColor = lineBackColor;
        self.lineColor = lineColor;
        self.backColor = backColor;
        self.progress = 0.0;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress <= 100.0 ? progress : 100.0;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth > 0 ? lineWidth : 0;
    [self setNeedsDisplay];
}

- (void)setLineBackColor:(UIColor *)lineBackColor
{
    _lineBackColor = lineBackColor ? lineBackColor : [UIColor lightGrayColor];
    [self setNeedsDisplay];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor ? backColor : [UIColor whiteColor];
    self.backgroundColor = backColor;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor ? lineColor : [UIColor blackColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [_backColor setFill];
    UIRectFill(rect);
    
    // 底层圆环
    [_lineBackColor set];
    UIBezierPath *pathBack = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_lineWidth / 2.0, _lineWidth / 2.0, rect.size.width - _lineWidth, rect.size.height - _lineWidth)];
    pathBack.lineWidth = _lineWidth;
    pathBack.lineCapStyle = kCGLineCapRound;
    pathBack.lineJoinStyle = kCGLineJoinRound;
    [pathBack stroke];
    
    // 进度圆环
    [_lineColor set];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0) radius:rect.size.width / 2.0 - _lineWidth / 2.0 startAngle:TO_RADIUS(- 90.0) endAngle:TO_RADIUS(- 90.0 + _progress / 100.0 * 360.0) clockwise:YES];
    path.lineWidth = _lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
