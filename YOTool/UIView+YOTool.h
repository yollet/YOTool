//
//  UIView+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YOTool)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat myTWidth;
@property (nonatomic, assign) CGFloat myTHeight;

/**
 局部圆角
 */
- (void)setRadiusWithTopLeft:(BOOL)topLeft topRight:(BOOL)topRight bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight radius:(CGFloat)radius;

/**
 加阴影
 */
- (void)addShadowWithColor:(UIColor *)color height:(CGFloat)height shadowOpacity:(CGFloat)shadowOpacity radius:(CGFloat)radius;

/**
 截图
 */
- (UIImage *)screenshotView;

@end

NS_ASSUME_NONNULL_END
