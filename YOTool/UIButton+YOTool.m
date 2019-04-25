//
//  UIButton+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIButton+YOTool.h"
#import "UIFont+YOTool.h"

@implementation UIButton (YOTool)

+ (UIButton *)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor font:(CGFloat)font radius:(CGFloat)radius
{
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.frame = frame;
    button.layer.cornerRadius = radius;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont yoBoldFontOfSize:font];
    [button setBackgroundColor:backColor];
    return button;
}

@end
