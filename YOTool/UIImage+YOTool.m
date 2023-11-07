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
        
        UIImage *resultImage = nil;
        
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRenderer *re = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
            resultImage = [re imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
                // 填充颜色
                [backColor setFill];
                
                UIRectFill(rect);
                // 贝塞尔裁切
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
                [path addClip];
                [self drawInRect:rect];
            }];
        } else {
            // 利用绘图建立上下文
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0);
            CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
            // 填充颜色
            [backColor setFill];
            
            UIRectFill(rect);
            // 贝塞尔裁切
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
            [path addClip];
            [self drawInRect:rect];
            
            // 获取结果
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
            // 主队列回调
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
        
    });
}

- (UIImage *)changeSizeTo:(CGSize)newSize
{
    UIImage *scaledImage = nil;
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *re = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
        scaledImage = [re imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        }];
    } else {
        // 需要的图片大小
        UIGraphicsBeginImageContext(newSize);
        // 将整个图片绘制到一个rect中
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        // 从当前context中创建一个改变大小后的图片
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
    }
    return scaledImage;
}

- (UIImage *)cutImageWithFrame:(CGRect)frame
{
    UIImage *scaledImage = nil;
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *re = [[UIGraphicsImageRenderer alloc] initWithSize:frame.size];
        scaledImage = [re imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [self drawInRect:CGRectMake(- frame.origin.x, - frame.origin.y, self.size.width, self.size.height)];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0); //开启位图上下文，决定裁剪后图片大小，也就是决定裁剪区域大小

        [self drawInRect:CGRectMake(- frame.origin.x, - frame.origin.y, self.size.width, self.size.height)];  //把待裁剪的图片绘制到该范围内

        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    
    return scaledImage;
}

#pragma mark -- 局部圆角 --
- (void)roundImageWithSize:(CGSize)size corner:(UIRectCorner)corner radiusSize:(CGSize)radiusSize backColor:(UIColor *)backColor completion:(void (^)(UIImage * _Nonnull))completion
{
    // 异步绘制裁切
    CGSize newSize = CGSizeMake(round(size.width), round(size.height));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *resultImage = nil;
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRenderer *re = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
            resultImage = [re imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
                // 填充颜色
                [backColor setFill];
                
                UIRectFill(rect);
                // 贝塞尔裁切
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radiusSize];
                [path addClip];
                [self drawInRect:rect];
            }];
        } else {
            // 利用绘图建立上下文
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0);
            CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
            // 填充颜色
            [backColor setFill];
            
            UIRectFill(rect);
            // 贝塞尔裁切
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radiusSize];
            [path addClip];
            [self drawInRect:rect];
            
            // 获取结果
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
            // 主队列回调
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
    });
}

#pragma mark -- 局部圆角绘制 --
- (void)roundImageWithSize:(CGSize)size corner:(UIRectCorner)corner radius:(CGFloat)radius completion:(void(^)(UIImage *newImage))completion
{
    [self roundImageWithSize:size corner:corner radiusSize:CGSizeMake(radius, radius) backColor:[UIColor clearColor] completion:completion];
}

@end
