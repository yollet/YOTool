//
//  UIButton+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.

//  UIButton类扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YOTool)

+ (UIButton *)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor font:(CGFloat)font radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
