//
//  UITextField+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UITextField+YOTool.h"
#import "UIFont+YOTool.h"

@implementation UITextField (YOTool)

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSInteger)textAlignment placeholder:(NSString *)placeholder
{
    self = [self initWithFrame:frame];
    if (self) {
        self.textColor = textColor;
        self.font = [UIFont yoSystemFontOfSize:font];
        if (textAlignment == 0) {
            self.textAlignment = NSTextAlignmentLeft;
        }
        else if (textAlignment == 1) {
            self.textAlignment = NSTextAlignmentCenter;
        }
        else if (textAlignment == 2) {
            self.textAlignment = NSTextAlignmentRight;
        }
        self.placeholder = placeholder;
    }
    return self;
}

@end
