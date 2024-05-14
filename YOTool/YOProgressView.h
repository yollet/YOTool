//
//  YOProgressView.h
//  YOTool
//
//  Created by yollet on 2024/5/14.
//  Copyright © 2024 jhj. All rights reserved.

//  带滑块的进度条

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// progress:0~100
typedef void(^YOProgressBlock)(CGFloat progress);

@interface YOProgressView : UIView

// 进度 (0~100)
@property (nonatomic, assign) CGFloat progress;
// 背景颜色
@property (nonatomic, strong) UIColor *backColor;
// 进度宽
@property (nonatomic, assign) CGFloat lineWidth;
// 背景条颜色
@property (nonatomic, strong) UIColor *lineBackColor;
// 进度颜色
@property (nonatomic, strong) UIColor *lineColor;
// 滑块颜色
@property (nonatomic, strong) UIColor *sliderColor;
// 左右边距
@property (nonatomic, assign) CGFloat spaceX;
// 上下边距
@property (nonatomic, assign) CGFloat spaceY;
// 是否隐藏滑块, 默认不隐藏
@property (nonatomic, assign) BOOL hidSlider;

@property (nonatomic, copy) YOProgressBlock panBlock;


- (void)addPanWithBlock:(YOProgressBlock)block;

@end

NS_ASSUME_NONNULL_END
