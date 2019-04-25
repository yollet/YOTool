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
    // 异步绘制裁切
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 利用绘图建立上下文
        UIGraphicsBeginImageContextWithOptions(size, true, 0);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 填充颜色
        [[UIColor whiteColor] setFill];
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


@end
