//
//  YORoundProgressView.h
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//  内切圆进度条

#import <YOTool/YOTool.h>

NS_ASSUME_NONNULL_BEGIN

@interface YORoundProgressView : YOBaseView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat lineWidth;
// 进度条背景色
@property (nonatomic, strong) UIColor *lineBackColor;
// 进度条颜色
@property (nonatomic, strong) UIColor *lineColor;
// 背景色
@property (nonatomic, strong) UIColor *backColor;

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineBackColor:(UIColor *)lineBackColor lineColor:(UIColor *)lineColor backColor:(UIColor *)backColor;

@end

NS_ASSUME_NONNULL_END
