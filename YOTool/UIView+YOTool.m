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

@end
