//
//  YOProgressView.m
//  YOTool
//
//  Created by yollet on 2024/5/14.
//  Copyright © 2024 jhj. All rights reserved.
//

#import "YOProgressView.h"
#import "YOTool.h"

@interface YOProgressView ()

@property (nonatomic, assign) BOOL paning;

@end

@implementation YOProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backColor = [UIColor whiteColor];
        _lineBackColor = [UIColor lightGrayColor];
        _lineColor = [UIColor blackColor];
        _sliderColor = [UIColor blackColor];
        _lineWidth = 5;
        _progress = 0;
        _hidSlider = NO;
        _spaceX = 0;
        _spaceY = 0;
    }
    return self;
    
}

- (void)addPanWithBlock:(YOProgressBlock)block
{
    self.panBlock = block;
    
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark -- 选择进度 --
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint po1 = [tap locationInView:self];
//    CGPoint po2 = CGPointMake(po1.x - (self.yo_left + self.spaceX), po1.y);
//    NSLog(@"point (%f, %f)", po2.x, po2.y);
    
    CGFloat value = po1.x;
    
    CGFloat progressValue = value / self.yo_width;
    if (progressValue < 0) {
        progressValue = 0;
    }
    if (progressValue > 1.00) {
        progressValue = 1.0;
    }
    self.progress = progressValue * 100.0;
    if (self.panBlock) {
        self.panBlock(progressValue * 100.0);
    }
    
}

#pragma mark -- 拖动进度条 --
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint po1 = [pan locationInView:self];
//    CGPoint po2 = CGPointMake(po1.x - (self.yo_left + self.spaceX), po1.y);
//    NSLog(@"point (%f, %f)", po2.x, po2.y);
    
    CGFloat value = po1.x;
    CGFloat progressValue = value / self.yo_width;
    if (progressValue < 0) {
        progressValue = 0;
    }
    if (progressValue > 1.00) {
        progressValue = 1.0;
    }
    if (progressValue >= 0 && progressValue <= 1.0) {

        self.progress = progressValue * 100.0;
        if (self.panBlock) {
            self.panBlock(progressValue * 100.0);
        }
        
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.paning = YES;
        }
        if (pan.state == UIGestureRecognizerStateEnded) {
            self.paning = NO;
            
        }
        else {
            
        }
    }
    
    
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor ? backColor : [UIColor whiteColor];
    self.backgroundColor = backColor;
    [self setNeedsDisplay];
}

- (void)setLineBackColor:(UIColor *)lineBackColor
{
    _lineBackColor = lineBackColor ? lineBackColor : [UIColor lightGrayColor];
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor ? lineColor : [UIColor blackColor];
    [self setNeedsDisplay];
}

- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor ? sliderColor : [UIColor blackColor];
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth > 0 ? lineWidth : 0;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress <= 100.0 ? progress : 100.0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_backColor setFill];
    UIRectFill(rect);
    
    [_lineBackColor set];
        
    UIBezierPath *path_1 = [UIBezierPath bezierPath];
    [path_1 moveToPoint:CGPointMake(_spaceX, self.yo_height / 2.0)];
    [path_1 addLineToPoint:CGPointMake(_spaceX + self.yo_width - 2 * _spaceX, self.yo_height / 2.0)];
    path_1.lineWidth = _lineWidth;
    
    path_1.lineCapStyle = kCGLineCapRound;
    path_1.lineJoinStyle = kCGLineJoinRound;
    [path_1 stroke];
    
    [_lineColor set];
    UIBezierPath *path_2 = [UIBezierPath bezierPath];
    [path_2 moveToPoint:CGPointMake(_spaceX, self.yo_height / 2.0)];
    [path_2 addLineToPoint:CGPointMake(_spaceX + (self.yo_width - 2 * _spaceX) * (_progress / 100.0), self.yo_height / 2.0)];
    path_2.lineWidth = _lineWidth;
    
    path_2.lineCapStyle = kCGLineCapRound;
    path_2.lineJoinStyle = kCGLineJoinRound;
    [path_2 stroke];
    
    if (!_hidSlider) {
        [_sliderColor set];
        UIBezierPath *path_3 = [UIBezierPath bezierPath];
        [path_3 moveToPoint:CGPointMake(_spaceX + (self.yo_width - 2 * _spaceX) * (_progress / 100.0), _spaceY)];
        [path_3 addLineToPoint:CGPointMake(_spaceX + (self.yo_width - 2 * _spaceX) * (_progress / 100.0), _spaceY + self.yo_height - 2 * _spaceY)];
        path_3.lineWidth = _lineWidth;

        path_3.lineCapStyle = kCGLineCapRound;
        path_3.lineJoinStyle = kCGLineJoinRound;
        [path_3 stroke];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
