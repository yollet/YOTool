//
//  YORoundExerciseProgress.m
//  YOTool
//
//  Created by jhj on 2022/2/22.
//  Copyright © 2022 jhj. All rights reserved.
//

#import "YORoundExerciseProgress.h"
#import <math.h>
#import "YOTool.h"

@interface YORoundExerciseProgress ()


@property (nonatomic, assign) CGFloat oldAngle;



@end

@implementation YORoundExerciseProgress

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius sliderSize:(CGSize)sliderSize lineWidth:(CGFloat)lineWidth lineBackColor:(UIColor *)lineBackColor lineColor:(UIColor *)lineColor backColor:(UIColor *)backColor sliderImage:(UIImage *)sliderImage textSize:(CGSize)textSize font:(nonnull UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backColor;
        self.radius = radius;
        self.lineWidth = lineWidth;
        self.lineBackColor = lineBackColor;
        self.lineColor = lineColor;
        self.sliderImage = sliderImage;
        self.textSize = textSize;
        self.font = font;
        
        self.progressView = [[YORoundProgressView alloc] initWithFrame:CGRectZero lineWidth:lineWidth lineBackColor:lineBackColor lineColor:lineColor backColor:backColor];
        [self addSubview:_progressView];
        
        if (radius < 0) {
            radius = 0;
        }
        else if (radius > frame.size.width / 2.0 + (sliderSize.height / 2.0 - lineWidth / 2.0)) {
            radius = frame.size.width / 2.0 + (sliderSize.height / 2.0 - lineWidth / 2.0);
        }
        self.progressView.yo_setWidth(radius * 2.0).yo_setHeight(radius * 2.0).yo_setCenterX(frame.size.width / 2.0).yo_setCenterY(frame.size.height / 2.0);
        self.progressView.progress = 0.0;
        
        CGFloat outRadius = self.radius + sliderSize.height / 2.0 + self.textSize.height / 2.0 - lineWidth / 2.0;
        CGFloat sliderViewWidth = (outRadius + textSize.height / 2.0) * 2.0;
        
        self.sliderView = [[YOBaseView alloc] initWithFrame:CGRectZero];
        self.sliderView.yo_setWidth(sliderViewWidth).yo_setHeight(sliderViewWidth).yo_setCenterX(frame.size.width / 2.0).yo_setCenterY(frame.size.height / 2.0);
        self.sliderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_sliderView];
        
        if (textSize.width != 0 && textSize.height != 0) {
            
            
            self.roundText = [[YORoundTextView alloc] initWithFrame:CGRectZero];
            self.roundText.yo_setTop(0).yo_setWidth(self.textSize.width).yo_setHeight(self.textSize.height).yo_setCenterX(self.sliderView.yo_width / 2.0);
            self.roundText.radius = outRadius;
            self.roundText.contextCenter = CGPointMake(self.roundText.yo_width / 2.0, self.roundText.yo_height / 2.0 - outRadius);
            self.roundText.startAngle = M_PI_2 - (textSize.width * 0.9 / outRadius) / 2.0 + M_PI;
            self.roundText.endAngle =  (textSize.width * 0.9 / outRadius) / 2.0 + M_PI_2 + M_PI; // 弧度长比宽度稍短防止显示不全
            self.roundText.font = font;
            [self.sliderView addSubview:_roundText];
        }
        
        
        self.slider = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.sliderView addSubview:self.slider];
        self.slider.yo_setWidth(sliderSize.width).yo_setHeight(sliderSize.height).yo_setCenterX(self.sliderView.frame.size.width / 2.0).yo_setCenterY(sliderSize.height / 2.0 + textSize.height);
        self.slider.image = sliderImage;
        
        self.slider.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self.slider addGestureRecognizer:pan];
        
        self.oldAngle = 0.0;
        
        self.backColor = backColor;
        
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint po1 = [pan locationInView:self];
    
    CGFloat angle = 0;
    
    CGPoint centrePoint = CGPointMake(self.yo_width / 2.0, self.yo_height / 2.0);
    CGPoint po2 = CGPointMake(po1.x - centrePoint.x, centrePoint.y - po1.y); // 因po1和中心点是frame的坐标系 向下为正 而正常坐标系向下为负 所以原来的po2坐标计算(y2 - y1)要变成(-y2 - (-y1)) = (y1 - y2)
    
    angle = AngleFromNorth(CGPointMake(0, 0), po2, NO);
    
//    NSLog(@"angle == %f", angle / M_PI * 180);
    
    
    
    angle = M_PI / 2.0 - angle;
    angle = angle > 0 ?  angle : angle + 2 * M_PI; // 修正坐标系
    
//    NSLog(@"ANGLE == %f", angle / M_PI * 180);
    
    CGAffineTransform trans = CGAffineTransformIdentity;
    trans = CGAffineTransformMakeRotation(angle);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(progressBeginSlide:)]) {
            if ([self.delegate progressBeginSlide:angle]) {
                
            }
            else {
                return;
            }
        }
        
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(progressSliding:)]) {
            if ([self.delegate progressSliding:angle]) {
                
            }
            else {
                return;
            }
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(progressEndSlide:)]) {
            if ([self.delegate progressEndSlide:angle]) {
                
            }
            else {
                return;
            }
        }
    }

    if (fabs(self.oldAngle - angle) < M_PI / 2.0) { // 限制单次移动的最大角 超出视为回到初始点
        self.sliderView.transform = trans;
        self.oldAngle = angle;
        
//        NSLog(@"%f", self.progress);
    }
    else {
        if (self.oldAngle - angle < 0) {
            if ([self.delegate respondsToSelector:@selector(progressRoundBegin:pan:)]) {
                if ([self.delegate progressRoundBegin:angle  pan:pan]) {
                    self.sliderView.transform = trans;
                    self.oldAngle = angle;
                }
                else {
                    
                }
            }
        }
        else if (self.oldAngle - angle > 0) {
            if ([self.delegate respondsToSelector:@selector(progressRoundEnd:pan:)]) {
                if ([self.delegate progressRoundEnd:angle pan:pan]) {
                    self.sliderView.transform = trans;
                    self.oldAngle = angle;
                }
                else {
                    
                }
            }
        }
    }
}



static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    double radians = atan2(v.y, v.x);
    return radians;
}

- (void)setSliderImage:(UIImage *)sliderImage
{
    self.slider.image = sliderImage;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress <= 100.0 ? progress : 100.0;
    self.progressView.progress = _progress;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.progressView.lineWidth = lineWidth;
}

- (void)setLineBackColor:(UIColor *)lineBackColor
{
    _lineBackColor = lineBackColor;
    self.progressView.lineBackColor = _lineBackColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.progressView.lineColor = _lineColor;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor ? backColor : [UIColor whiteColor];
    self.progressView.backColor = _backColor;
    self.slider.backgroundColor = _backColor;
    self.roundText.backColor = _backColor;
}

- (void)setMaxSecond:(NSInteger)maxSecond
{
    _maxSecond = maxSecond;
    NSInteger second = 0;
    NSString *secondStr = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", second / 60, second % 60, _maxSecond / 60, _maxSecond % 60];
    self.roundText.roundString = secondStr;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.roundText.textColor = textColor ? textColor : [UIColor blackColor];
}

- (void)setSecond:(NSInteger)second
{
    if (_second == second) {
        return;
    }
    _second = second;
    
    NSString *secondStr = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", second / 60, second % 60, _maxSecond / 60, _maxSecond % 60];
    
//    NSLog(@"=================%ld, %@", second, secondStr);
    self.roundText.roundString = secondStr;
    
}

- (void)setFont:(UIFont *)font
{
    if (!font) {
        return;
    }
    _font = font;
    self.roundText.font = font;
}

- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    self.roundText.roundString = textString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    self.roundText.attString = attributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
