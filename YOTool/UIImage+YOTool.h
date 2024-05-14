//
//  UIImage+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.

//  扩展UIImage功能

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YOTool)

/**
 圆角绘制
 */
- (void)roundImageWithSize:(CGSize)size radius:(CGFloat)radius completion:(void(^)(UIImage *newImage))completion;

/**
 圆角绘制（设置背景色）
 */
- (void)roundImageWithSize:(CGSize)size radius:(CGFloat)radius backColor:(UIColor *)backColor completion:(void(^)(UIImage *newImage))completion;

/**
 修改图片尺寸
 */
- (UIImage *)changeSizeTo:(CGSize)newSize;

/**
 局部圆角绘制
 */
- (void)roundImageWithSize:(CGSize)size corner:(UIRectCorner)corner radius:(CGFloat)radius completion:(void(^)(UIImage *newImage))completion;

/**
 局部圆角(设置背景色)
 */
- (void)roundImageWithSize:(CGSize)size corner:(UIRectCorner)corner radiusSize:(CGSize)radiusSize backColor:(UIColor *)backColor completion:(void (^)(UIImage * _Nonnull))completion;

/**
 裁剪图片
 */
- (UIImage *)cutImageWithFrame:(CGRect)frame;

// 异步
- (void)cutImageWithFrame:(CGRect)frame completion:(void(^)(UIImage *newImage))completion;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage *)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


@end

NS_ASSUME_NONNULL_END
