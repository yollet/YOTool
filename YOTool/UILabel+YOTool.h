//
//  UILabel+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.

//  Label类扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (YOTool)

/**
 textAlignment : 0 1 2 左 中 右
 */
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSInteger)textAlignment;

/**
 适配高度
 */
- (CGFloat)adaptiveHeight;

/**
 适配宽度
 */
- (CGFloat)adaptiveWidth;

@end

NS_ASSUME_NONNULL_END
