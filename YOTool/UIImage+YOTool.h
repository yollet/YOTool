//
//  UIImage+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

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

@end

NS_ASSUME_NONNULL_END
