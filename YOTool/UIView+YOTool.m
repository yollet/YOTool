//
//  UIView+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIView+YOTool.h"
#import <objc/runtime.h>
#import "YOTool.h"

@implementation UIView (YOTool)

#pragma mark -- 左 --
- (void)setYo_left:(CGFloat)yo_left
{
    CGRect frame = self.frame;
    frame.origin.x = yo_left;
    self.frame = frame;
}

- (CGFloat)yo_left
{
    return self.frame.origin.x;
}

#pragma mark -- 右 --
- (void)setYo_right:(CGFloat)yo_right
{
    CGRect frame = self.frame;
    frame.origin.x = yo_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)yo_right
{
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark -- 上 --
- (void)setYo_top:(CGFloat)yo_top
{
    CGRect frame = self.frame;
    frame.origin.y = yo_top;
    self.frame = frame;
}

- (CGFloat)yo_top
{
    return self.frame.origin.y;
}

- (void)setYo_centerX:(CGFloat)yo_centerX {
    CGPoint center = self.center;
    center.x = yo_centerX;
    self.center = center;
}

- (CGFloat)yo_centerX {
    return self.center.x;
}

- (void)setYo_centerY:(CGFloat)yo_centerY {
    CGPoint center = self.center;
    center.y = yo_centerY;
    self.center = center;
}

- (CGFloat)yo_centerY {
    return self.center.y;
}



#pragma mark -- 下 --
- (void)setYo_bottom:(CGFloat)yo_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = yo_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)yo_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark -- 宽 --
- (void)setYo_width:(CGFloat)yo_width
{
    CGRect frame = self.frame;
    frame.size.width = yo_width;
    self.frame = frame;
}

- (CGFloat)yo_width
{
    return self.frame.size.width;
}

- (UIViewController *)yo_viewController {
    UIView *view = self;
    while (view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
        
      }
    return nil;
}

/*
static void *kUIViewLayoutMethodPropertyBottomGap = &kUIViewLayoutMethodPropertyBottomGap;
static void *kUIViewLayoutMethodPropertyTopGap = &kUIViewLayoutMethodPropertyTopGap;
static void *kUIViewLayoutMethodPropertyLeftGap = &kUIViewLayoutMethodPropertyLeftGap;
static void *kUIViewLayoutMethodPropertyRightGap = &kUIViewLayoutMethodPropertyRightGap;

- (CGFloat)yo_safeTop
{
    if (!self.yo_viewController) {
        return 0;
    }
    if (@available(iOS 11, *)) {
        return self.yo_viewController.view.safeAreaInsets.top;
    } else {
        return 0;
    }
}

- (CGFloat)yo_safeBottom
{
    if (!self.yo_viewController) {
        return 0;
    }
    if (@available(iOS 11, *)) {
        return self.yo_viewController.view.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

- (CGFloat)yo_safeLeft
{
    if (!self.yo_viewController) {
        return 0;
    }
    if (@available(iOS 11, *)) {
        return self.yo_viewController.view.safeAreaInsets.left;
    } else {
        return 0;
    }
}

- (CGFloat)yo_safeRight
{
    if (!self.yo_viewController) {
        return 0;
    }
    if (@available(iOS 11, *)) {
        return self.yo_viewController.view.safeAreaInsets.right;
    } else {
        return 0;
    }
}
 */

#pragma mark -- 高 --
- (void)setYo_height:(CGFloat)yo_height
{
    CGRect frame = self.frame;
    frame.size.height = yo_height;
    self.frame = frame;
}

- (CGFloat)yo_height
{
    return self.frame.size.height;
}

- (UIView *(^)(CGFloat))yo_setTop {
    @yo_weakify(self);
    return ^(CGFloat y_top){
        @yo_strongify(self);
        self.yo_top = y_top;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setBottom {
    @yo_weakify(self);
    return ^(CGFloat y_bottom){
        @yo_strongify(self);
        self.yo_bottom = y_bottom;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setLeft {
    @yo_weakify(self);
    return ^(CGFloat y_left){
        @yo_strongify(self);
        self.yo_left = y_left;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setRight {
    @yo_weakify(self);
    return ^(CGFloat y_right){
        @yo_strongify(self);
        self.yo_right = y_right;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setWidth {
    @yo_weakify(self);
    return ^(CGFloat y_width){
        @yo_strongify(self);
        self.yo_width = y_width;
        return self;
    };
}
-(UIView *(^)(CGFloat))yo_setHeight {
    @yo_weakify(self);
    return ^(CGFloat y_height){
        @yo_strongify(self);
        self.yo_height = y_height;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_FTop {
    @yo_weakify(self);
    return ^(CGFloat y_top){
        @yo_strongify(self);
        self.yo_setTop(FitY(y_top));
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_FBottom {
    @yo_weakify(self);
    return ^(CGFloat y_bottom){
        @yo_strongify(self);
        self.yo_setBottom(FitY(y_bottom));
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_FLeft {
    @yo_weakify(self);
    return ^(CGFloat y_left){
        @yo_strongify(self);
        self.yo_setLeft(FitX(y_left));
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_FRight {
    @yo_weakify(self);
    return ^(CGFloat y_right){
        @yo_strongify(self);
        self.yo_setRight(FitX(y_right));
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_FWidth {
    @yo_weakify(self);
    return ^(CGFloat y_width){
        @yo_strongify(self);
        self.yo_setWidth(FitX(y_width));
        return self;
    };
}
-(UIView *(^)(CGFloat))yo_FHeight {
    @yo_weakify(self);
    return ^(CGFloat y_height){
        @yo_strongify(self);
        self.yo_setHeight(FitY(y_height));
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setCenterX {
    @yo_weakify(self);
    return ^(CGFloat x){
        @yo_strongify(self);
        NSAssert(self.yo_width, @"must set width first");
        self.yo_centerX = x;
        return self;
    };
}

- (UIView *(^)(CGFloat))yo_setCenterY {
    @yo_weakify(self);
    return ^(CGFloat y){
        @yo_strongify(self);
        NSAssert(self.yo_height, @"must set height first");
        self.yo_centerY = y;
        return self;
    };
}

- (void)setRadiusWithTopLeft:(BOOL)topLeft topRight:(BOOL)topRight bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight radius:(CGFloat)radius
{
    UIRectCorner con = 0;
    if (topLeft) {
        con = con | UIRectCornerTopLeft;
    }
    if (topRight) {
        con = con | UIRectCornerTopRight;
    }
    if (bottomLeft) {
        con = con | UIRectCornerBottomLeft;
    }
    if (bottomRight) {
        con = con | UIRectCornerBottomRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:con cornerRadii:CGSizeMake(radius,radius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addShadowWithColor:(UIColor *)color height:(CGFloat)height shadowOpacity:(CGFloat)shadowOpacity radius:(CGFloat)radius
{
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.yo_width, self.yo_height)].CGPath;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, height);
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.cornerRadius = radius;
}

- (UIImage *)screenshotView
{
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *newView = (UIScrollView *)self;
        UIImage *image;
        if (newView.contentSize.height > newView.yo_height) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newView.yo_width, newView.contentSize.height), NO, 0.0);
            {
                CGPoint saveOffict = newView.contentOffset;
                CGRect saveFrame = newView.frame;
                newView.contentOffset = CGPointZero;
                newView.frame = CGRectMake(newView.yo_left, newView.yo_top, newView.yo_width, newView.contentSize.height);
                [newView.layer renderInContext:UIGraphicsGetCurrentContext()];
                image = UIGraphicsGetImageFromCurrentImageContext();
                newView.contentOffset = saveOffict;
                newView.frame = saveFrame;
            }
            UIGraphicsEndImageContext();
            return image;
        }
        else {
            
            UIView *newView = self;
            UIGraphicsBeginImageContextWithOptions(newView.bounds.size, NO, 0.0);
            [newView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image;
        }
        
    }
    else {
        UIView *newView = self;
        UIGraphicsBeginImageContextWithOptions(newView.bounds.size, NO, 0.0);
        [newView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (UIColor *)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
     
        CGContextTranslateCTM(context, -point.x, -point.y);
     
        [self.layer renderInContext:context];
     
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
     
        UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
     
        return color;

}

- (void)addColorWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations type:(NSInteger)type
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *tempColor in colors) {
        [cgColors addObject:(__bridge id)tempColor.CGColor];
    }
    gradientLayer.colors = cgColors;
    gradientLayer.locations = locations;
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    
    if (type == 1) {
        end = CGPointMake(1.0, 0);
    }
    else if (type == 2) {
        end = CGPointMake(0, 1.0);
    }
    else if (type == 3) {
        end = CGPointMake(1.0, 1.0);
    }
    else if (type == 4) {
        start = CGPointMake(1.0, 1.0);
        end = CGPointMake(0, 0);
    }
    gradientLayer.startPoint = start;
    gradientLayer.endPoint = end;
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}

@end
