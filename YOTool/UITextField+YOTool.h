//
//  UITextField+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.

//  UITextField类扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (YOTool)

/**
 textAlignment : 0 1 2 左 中 右
 */
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSInteger)textAlignment placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
