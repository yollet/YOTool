//
//  UIView+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIView+YOTool.h"

@implementation UIView (YOTool)

#pragma mark -- 左 --
- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

#pragma mark -- 右 --
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark -- 上 --
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

#pragma mark -- 下 --
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark -- 宽 --
- (void)setMyTWidth:(CGFloat)myTWidth
{
    CGRect frame = self.frame;
    frame.size.width = myTWidth;
    self.frame = frame;
}

- (CGFloat)myTWidth
{
    return self.frame.size.width;
}

#pragma mark -- 高 --
- (void)setMyTHeight:(CGFloat)myTHeight
{
    CGRect frame = self.frame;
    frame.size.height = myTHeight;
    self.frame = frame;
}

- (CGFloat)myTHeight
{
    return self.frame.size.height;
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
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.myTWidth, self.myTHeight)].CGPath;
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
        if (newView.contentSize.height > newView.myTHeight) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newView.myTWidth, newView.contentSize.height), NO, 0.0);
            {
                CGPoint saveOffict = newView.contentOffset;
                CGRect saveFrame = newView.frame;
                newView.contentOffset = CGPointZero;
                newView.frame = CGRectMake(newView.left, newView.top, newView.myTWidth, newView.contentSize.height);
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

@end
