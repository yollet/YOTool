//
//  UIFont+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (YOTool)

+ (UIFont *)yoSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)yoBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)yoNoBoldFontOfSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
