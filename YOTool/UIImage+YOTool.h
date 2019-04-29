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

@end

NS_ASSUME_NONNULL_END
