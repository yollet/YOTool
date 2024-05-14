//
//  UIView+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.

//  UIView的扩展，包括点语法布局，添加圆角，添加渐变色等

#import <UIKit/UIKit.h>

#define yo_weakify(object) autoreleasepool   {} __weak  typeof(object) weak##object = object;
#define yo_strongify(object) autoreleasepool {} __strong  typeof(weak##object) object = weak##object;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YOTool)

@property (nonatomic, assign) CGFloat yo_left;
@property (nonatomic, assign) CGFloat yo_right;
@property (nonatomic, assign) CGFloat yo_top;
@property (nonatomic, assign) CGFloat yo_bottom;
@property (nonatomic, assign) CGFloat yo_width;
@property (nonatomic, assign) CGFloat yo_height;

@property (nonatomic) CGFloat yo_centerX;      
@property (nonatomic) CGFloat yo_centerY;

@property (readonly) UIViewController *yo_viewController;  //self Responder UIViewControler

/*
   示例链接编程
   self.yo_width(100).yo_height(100).yo_left(10).yo_top(10)
*/
- (UIView * (^)(CGFloat top))yo_setTop;            ///< set frame y
- (UIView * (^)(CGFloat bottom))yo_setBottom;      ///< set frame y
- (UIView * (^)(CGFloat left))yo_setLeft;          ///< set frame x
- (UIView * (^)(CGFloat right))yo_setRight;        ///< set frame x
- (UIView * (^)(CGFloat width))yo_setWidth;        ///< set frame width
- (UIView * (^)(CGFloat height))yo_setHeight;      ///< set frame height
- (UIView * (^)(CGFloat x))yo_setCenterX;         ///< set center
- (UIView * (^)(CGFloat y))yo_setCenterY;         ///< set center
///
- (UIView * (^)(CGFloat top))yo_FTop;            ///< set frame y
- (UIView * (^)(CGFloat bottom))yo_FBottom;      ///< set frame y
- (UIView * (^)(CGFloat left))yo_FLeft;          ///< set frame x
- (UIView * (^)(CGFloat right))yo_FRight;        ///< set frame x
- (UIView * (^)(CGFloat width))yo_FWidth;        ///< set frame width
- (UIView * (^)(CGFloat height))yo_FHeight;      ///< set frame height

//// 对全面屏适配 ()
//@property (readonly) CGFloat yo_safeTop;
//@property (readonly) CGFloat yo_safeBottom;
//@property (readonly) CGFloat yo_safeLeft;
//@property (readonly) CGFloat yo_safeRight;

/**
 局部圆角
 */
- (void)setRadiusWithTopLeft:(BOOL)topLeft topRight:(BOOL)topRight bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight radius:(CGFloat)radius;

/**
 加阴影
 */
- (void)addShadowWithColor:(UIColor *)color height:(CGFloat)height shadowOpacity:(CGFloat)shadowOpacity radius:(CGFloat)radius;

/**
 截图
 */
- (UIImage *)screenshotView;

/**
 提取某坐标的颜色
 */
- (UIColor *)colorOfPoint:(CGPoint)point;

/**
 添加渐变色
 colors : 渐变颜色组
 locations : 0~1的颜色分割比例
 type : 1 横向 2 竖向 3 左上-右下 4 左下-右上
 */
- (void)addColorWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
