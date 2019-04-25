//
//  UIFont+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIFont+YOTool.h"
#import "YOTool.h"

@implementation UIFont (YOTool)

+ (UIFont *)yoSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:FitX(fontSize)];
}

+ (UIFont *)yoBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:FitX(fontSize)];
}

+ (UIFont *)yoNoBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Helvetica" size:FitX(fontSize)];
}

@end
