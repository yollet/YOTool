//
//  UIImage+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIImage+YOTool.h"

@implementation UIImage (YOTool)

#pragma mark -- 圆角绘制 --
- (void)roundImageWithSize:(CGSize)size radius:(CGFloat)radius completion:(void(^)(UIImage *newImage))completion
{
    [self roundImageWithSize:size radius:radius backColor:[UIColor clearColor] completion:completion];
}

- (void)roundImageWithSize:(CGSize)size radius:(CGFloat)radius backColor:(UIColor *)backColor  completion:(void(^)(UIImage *newImage))completion
{
    // 异步绘制裁切
    CGSize newSize = CGSizeMake(round(size.width), round(size.height));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 利用绘图建立上下文
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0);
        CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
        // 填充颜色
        [backColor setFill];
//        [[UIColor colorWithRed:1 green:1 blue:1 alpha:0] setFill];
//        [[UIColor clearColor] setFill];
        
        UIRectFill(rect);
        // 贝塞尔裁切
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        [path addClip];
        [self drawInRect:rect];
        
        // 获取结果
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        // 主队列回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
    });
}

- (UIImage *)changeSizeTo:(CGSize)newSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
