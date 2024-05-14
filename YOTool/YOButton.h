//
//  YOButton.h
//  YOTool
//
//  Created by jhj on 2023/8/29.
//  Copyright © 2023 jhj. All rights reserved.

//  点语法布局的Button, 支持一图一文本的格式化或自定义布局
//  例如
/*
    btn = [YOButton buttonWithType:UIButtonTypeSystem];
    btn.frame = someFrame;
    btn.yo_setDefault(YOTopImageType).yo_setBottomSpace(10);
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YOButtonType) {
    // -----常规类型
    YODefaultType = 0,
    YOImageType = 1 << 0,
    YOTextType = 1 << 1,
    YOLeftImageType = 1 << 2,
    YORightImageType = 1 << 3,
    YOTopImageType = 1 << 4,
    YOBottomImageType = 1 << 5,
    
    // -----定制类型
    YORoundType = 1 << 6,
    YOBorderType = 1 << 7,
    YORightRoundType = 1 << 8, // 右边半圆角
    YOBackImageType = 1 << 9, // 背景全图
    YOBackImageTextType = 1 << 10, // 背景全图加文字
    YORedLineSelectType = 1 << 11, // 红线选择按钮
    YOSelectType = 1 << 12, // 无线选择按钮
};

@interface YOButton : UIButton

@property (nonatomic, strong) UIImageView *yo_imageView;
@property (nonatomic, strong) UILabel *yo_label;

@property (nonatomic, assign) YOButtonType yo_type;
@property (nonatomic, assign) CGFloat yo_multiple;
@property (nonatomic, assign) CGFloat yo_radius;
@property (nonatomic, assign) CGFloat yo_borderWidth;
@property (nonatomic, assign) CGFloat yo_leftSpace;
@property (nonatomic, assign) CGFloat yo_rightSpace;
@property (nonatomic, assign) CGFloat yo_topSpace;
@property (nonatomic, assign) CGFloat yo_bottomSpace;
@property (nonatomic, assign) CGSize yo_imageSize;
@property (nonatomic, assign, readonly) BOOL haveSetSize;

@property (nonatomic, strong) UIColor *yo_borderColor;
@property (nonatomic, strong) UIColor *yo_backColor;
@property (nonatomic, strong) UIColor *yo_textColor;
@property (nonatomic, strong) UIImage *yo_image;
@property (nonatomic, strong) NSString *yo_text;
@property (nonatomic, assign) BOOL yo_fitTextWidth;
@property (nonatomic, strong) UIFont *yo_font;
@property (nonatomic, assign) BOOL yo_unusable;
@property (nonatomic, assign) BOOL yo_select;

@property (nonatomic, strong) UIColor *yo_normalTextColor;
@property (nonatomic, strong) UIColor *yo_highlightTextColor;


- (YOButton *(^)(YOButtonType type))yo_setType;

- (YOButton *(^)(YOButtonType type))yo_setDefault;

- (YOButton *(^)(CGFloat yo_multiple))yo_setMultiple;

- (YOButton *(^)(CGFloat yo_radius))yo_setRadius;

- (YOButton *(^)(CGFloat yo_borderWidth))yo_setBorderWidth;

- (YOButton *(^)(CGFloat yo_leftSpace))yo_setLeftSpace;

- (YOButton *(^)(CGFloat yo_rightSpace))yo_setRightSpace;

- (YOButton *(^)(CGFloat yo_topSpace))yo_setTopSpace;

- (YOButton *(^)(CGFloat yo_bottomSpace))yo_setBottomSpace;

- (YOButton *(^)(CGSize yo_imageSize))yo_setImageSize;

- (YOButton *(^)(BOOL yo_fitTextWidth))yo_setFitTextWidth;

- (YOButton *(^)(BOOL yo_unusable))yo_setUnusable;

- (YOButton *(^)(BOOL yo_select))yo_setSelect;


- (YOButton *(^)(UIColor *yo_borderColor))yo_setBorderColor;

- (YOButton *(^)(UIColor *yo_backColor))yo_setBackColor;

- (YOButton *(^)(UIColor *yo_textColor))yo_setTextColor;

- (YOButton *(^)(UIColor *yo_normalTextColor))yo_setNormalTextColor;

- (YOButton *(^)(UIColor *yo_highlightTextColor))yo_setHighlightTextColor;

- (YOButton *(^)(UIImage *yo_image))yo_setImage;

- (YOButton *(^)(NSString *yo_text))yo_setText;

- (YOButton *(^)(UIFont *yo_font))yo_setFont;

@end

NS_ASSUME_NONNULL_END
