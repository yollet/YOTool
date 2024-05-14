//
//  UIImage+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIImage+YOTool.h"

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

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

- (void)cutImageWithFrame:(CGRect)frame completion:(void(^)(UIImage *newImage))completion
{
    // 异步绘制裁切
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *resultImage = nil;
        
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRenderer *re = [[UIGraphicsImageRenderer alloc] initWithSize:self.size];
            resultImage = [re imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGRect rect = frame;
                // 填充颜色
                [[UIColor clearColor] setFill];
                
                UIRectFill(rect);
                // 贝塞尔裁切
                UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
                [path addClip];
                [self drawInRect:rect];
            }];
        } else {
            // 利用绘图建立上下文
            UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
            // 填充颜色
            [[UIColor clearColor] setFill];
            
            CGRect rect = frame;
            UIRectFill(rect);
            // 贝塞尔裁切
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
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

#pragma mark -- 纠正图片的方向 --
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark -- 按给定的方向旋转图片 --
- (UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

#pragma mark -- 垂直翻转 --
- (UIImage *)flipVertical
{
    return [self rotate:UIImageOrientationDownMirrored];
}

#pragma mark -- 水平翻转 --
- (UIImage *)flipHorizontal
{
    return [self rotate:UIImageOrientationUpMirrored];
}

#pragma mark -- 将图片旋转弧度radians --
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark -- 将图片旋转角度degrees --
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:kDegreesToRadian(degrees)];
}

#pragma mark -- 交换宽和高 --
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

@end
