//
//  YORoundExerciseProgress.h
//  YOTool
//
//  Created by jhj on 2022/2/22.
//  Copyright © 2022 jhj. All rights reserved.
//  圆形进度条

#import "YOBaseView.h"
#import "YORoundTextView.h"
#import "YORoundProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YORoundExerciseProgressDelegate <NSObject>

@optional

/**
 // 滑动开始时  默认为YES  设置为NO时关闭开始时的滑动
 */
- (BOOL)progressBeginSlide:(CGFloat)angle;

/**
 * 滑动进行时  默认为YES  设置为NO时关闭进行时的滑动
 */
- (BOOL)progressSliding:(CGFloat)angle;

/**
  // 滑动结束时  默认为YES  设置为NO时关闭结束时的滑动
 */
- (BOOL)progressEndSlide:(CGFloat)angle;

/**
  // 滑至起点时 默认为NO  设置为YES时可逆时针循环滑动
 */
- (BOOL)progressRoundBegin:(CGFloat)angle pan:(UIPanGestureRecognizer *)pan;

/**
  // 滑至终点时  默认为NO  设置为YES时可顺时针循环滑动
 */
- (BOOL)progressRoundEnd:(CGFloat)angle pan:(UIPanGestureRecognizer *)pan;



@end

@interface YORoundExerciseProgress : YOBaseView

// 环形进度条
@property (nonatomic, strong) YORoundProgressView *progressView;
// 旋转的背景板
@property (nonatomic, strong) YOBaseView *sliderView;
// 弧形文字
@property (nonatomic, strong) YORoundTextView *roundText;
// 滑块
@property (nonatomic, strong) UIImageView *slider;

// 圆环进度条半径
@property (nonatomic, assign) CGFloat radius;
// 进度
@property (nonatomic, assign) CGFloat progress;
// 进度条宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 进度条背景色
@property (nonatomic, strong) UIColor *lineBackColor;
// 进度条颜色
@property (nonatomic, strong) UIColor *lineColor;
// 圆环背景色
@property (nonatomic, strong) UIColor *backColor;
// 滑块背景色
@property (nonatomic, strong) UIColor *sliderBackColor;
// 滑块图片
@property (nonatomic, strong) UIImage *sliderImage;

// 弧形字体范围
@property (nonatomic, assign) CGSize textSize;
// 最大进度值
@property (nonatomic, assign) NSInteger maxSecond;
// 字体颜色
@property (nonatomic, strong) UIColor *textColor;
// 字体大小
@property (nonatomic, strong) UIFont *font;

/**下面三种属性皆可以改变文字内容 按需选择一种方式*/
// 当前进度值 (mm:ss/mm:ss)
@property (nonatomic, assign) NSInteger second;
// 字体内容
@property (nonatomic, strong) NSString *textString;
// 富文本字体内容
@property (nonatomic, strong) NSAttributedString *attributedString;


@property (nonatomic, weak) id<YORoundExerciseProgressDelegate> delegate;

/**
 !请务必使用此方法初始化
 @frame : frame
 @radius : 进度条半径
 @sliderSize : 滑块尺寸(不能超出frame范围)
 @lineWidth : 进度条宽度
 @lineBackColor : 进度条背颜色
 @lineColor : 进度条颜色
 @backColor: 背景色
 @sliderImage ：进度条滑块图
 @textSize : 弧形文字范围 传zero时为没有文字
 @font : 字体大小
 */
- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius sliderSize:(CGSize)sliderSize lineWidth:(CGFloat)lineWidth lineBackColor:(UIColor *)lineBackColor lineColor:(UIColor *)lineColor backColor:(UIColor *)backColor sliderImage:(UIImage *)sliderImage textSize:(CGSize)textSize font:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
