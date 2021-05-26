//
//  UILabel+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UILabel+YOTool.h"
#import "UIFont+YOTool.h"

@implementation UILabel (YOTool)

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSInteger)textAlignment
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
    }
    return self;
}

- (void)adaptiveHeight
{
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bounds.size.height + 5);
}

@end
