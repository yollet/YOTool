//
//  YORoundTextView.h
//  YOTool
//
//  Created by jhj on 2022/2/24.
//  Copyright © 2022 jhj. All rights reserved.

//  弧形文字

#import "YOBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YORoundTextView : YOBaseView

/**弧形文字位置参数*/
// 圆弧半径
@property (nonatomic, assign) CGFloat radius;
// 字体的开始角度(圆弧坐标系 顺时针) →
@property (nonatomic, assign) CGFloat startAngle;
// 字体的结束角度(圆弧坐标系 顺时针)  →
@property (nonatomic, assign) CGFloat endAngle;
// 绘画的原点 初始原点为view左下角 向上为正 ↑→
@property (nonatomic, assign) CGPoint contextCenter;

/**弧形文字内容参数*/
@property (nonatomic, strong) NSString *roundString;
// 字体
@property (nonatomic, strong) UIFont *font;
// 字符颜色
@property (nonatomic, strong) UIColor *textColor;
// 也可直接用NSAttributedString
@property (nonatomic, strong) NSAttributedString *attString;
// 背景色
@property (nonatomic, strong) UIColor *backColor;

- (instancetype)initWithFrame:(CGRect)frame roundString:(NSString *)roundString font:(UIFont *)font radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle contextCenter:(CGPoint)contextCenter;

@end

NS_ASSUME_NONNULL_END
