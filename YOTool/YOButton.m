//
//  YOButton.m
//  YOTool
//
//  Created by jhj on 2023/8/29.
//  Copyright © 2023 jhj. All rights reserved.
//

#import "YOButton.h"
#import "YOTool.h"

@implementation YOButton

- (YOButton *(^)(YOButtonType type))yo_setType
{
    @yo_weakify(self);
    return ^(YOButtonType type){
        @yo_strongify(self);
        self.yo_type = type;
        return self;
    };
}

- (void)setYo_type:(YOButtonType)yo_type
{
    _yo_type = yo_type;
    NSAssert(self.yo_width, @"must set frame first");
    switch (yo_type) {
        case YODefaultType:
            self.layer.cornerRadius = 0;
            self.layer.borderWidth = 0;
            break;
        case YOImageType:
            self.yo_imageView.frame = self.bounds;
            break;
        case YOTextType:
            self.yo_label.frame = self.bounds;
            break;
        case YOLeftImageType:
            self.yo_imageView.yo_setLeft(0).yo_setTop(0).yo_setHeight(self.yo_height).yo_setWidth(self.yo_imageView.yo_height);
            [self fitLeftTypeLabel];
            break;
        case YORightImageType:
            self.yo_imageView.yo_setHeight(self.yo_height).yo_setWidth(self.yo_imageView.yo_height).yo_setTop(0).yo_setRight(self.yo_width);
            [self fitRightTypeLabel];
            break;
        case YOTopImageType:
            self.yo_imageView.yo_setWidth(self.yo_width).yo_setHeight(self.yo_imageView.yo_width).yo_setTop(0).yo_setLeft(0);
            [self fitTopTypeLabel];
            self.yo_label.textAlignment = NSTextAlignmentCenter;
            break;
        case YOBottomImageType:
            self.yo_imageView.yo_setWidth(self.yo_width).yo_setHeight(self.yo_imageView.yo_width).yo_setBottom(self.yo_height).yo_setLeft(0);
            [self fitBottomTypeLabel];
            self.yo_label.textAlignment = NSTextAlignmentCenter;
            break;
            
        default:
            break;
    }
}

- (void)fitLeftTypeLabel
{
    self.yo_label.yo_setLeft(self.yo_imageView.yo_right + FitX(5)).yo_setTop(0).yo_setWidth(self.yo_width - self.yo_label.yo_left).yo_setHeight(self.yo_height);
    self.yo_label.textAlignment = NSTextAlignmentLeft;
}

- (void)fitRightTypeLabel
{
    self.yo_label.yo_setLeft(0).yo_setTop(0).yo_setWidth(self.yo_imageView.yo_left).yo_setHeight(self.yo_height);
}

- (void)fitTopTypeLabel
{
    self.yo_label.yo_setLeft(0).yo_setTop(self.yo_imageView.yo_bottom + FitY(5)).yo_setWidth(self.yo_width).yo_setHeight(self.yo_height - self.yo_label.yo_top);
}

- (void)fitBottomTypeLabel
{
    self.yo_label.yo_setLeft(0).yo_setTop(0).yo_setWidth(self.yo_width).yo_setHeight(self.yo_imageView.yo_top - FitY(5));
}

#pragma mark -- 默认样式 --
- (YOButton *(^)(YOButtonType type))yo_setDefault
{
    @yo_weakify(self);
    return ^(YOButtonType type){
        @yo_strongify(self);
        self.yo_type = type;
        [self setDefault];
        return self;
    };
}

- (void)setDefault
{
    switch (_yo_type) {
        case YORoundType:
            self.yo_setType(YOTextType).yo_setRadius(self.yo_height / 2.0).yo_setTextColor([UIColor blackColor]).yo_setBackColor([UIColor orangeColor]);
            _yo_type = YORoundType;
            break;
            
        case YOBorderType:
            self.yo_setType(YOTextType).yo_setRadius(self.yo_height / 2.0).yo_setBorderWidth(1).yo_setBorderColor([UIColor grayColor]);
            _yo_type = YOBorderType;
            break;
            
        case YORightRoundType:
            self.yo_setType(YOTextType);
            [self setRadiusWithTopLeft:NO topRight:YES bottomLeft:NO bottomRight:YES radius:self.yo_height / 2.0];
            self.yo_setBackColor([UIColor blackColor]).yo_setTextColor([UIColor whiteColor]);
            _yo_type = YORightRoundType;
            break;
            
        case YOBackImageType:
            self.yo_setType(YOImageType);
            _haveSetSize = YES;
            _yo_type = YOBackImageType;
            break;
            
        case YOBackImageTextType:
            self.yo_setDefault(YOBackImageType);
            self.yo_label.frame = self.bounds;
            self.yo_setFont([UIFont yoBoldFontOfSize:20]).yo_setTextColor([UIColor whiteColor]);
            _yo_type = YOBackImageTextType;
            break;
            
        case YORedLineSelectType:
            self.yo_setDefault(YOBottomImageType).yo_setNormalTextColor([UIColor grayColor]).yo_setHighlightTextColor([UIColor redColor]);
            self.yo_setImageSize(CGSizeMake(FitX(26), FitY(4)));
            self.yo_imageView.backgroundColor = [UIColor redColor];
            self.yo_imageView.layer.cornerRadius = _yo_imageView.yo_height / 2.0;
            self.yo_imageView.hidden = YES;
            _yo_type = YORedLineSelectType | YOBottomImageType;
            break;
        case YOSelectType:
            self.yo_setDefault(YOTextType).yo_setNormalTextColor([UIColor grayColor]).yo_setHighlightTextColor([UIColor redColor]);
            _yo_type = YOSelectType | YOTextType;
            break;
            
        default:
            break;
    }
}

#pragma mark -- Multiple（图片占比） --
- (YOButton *(^)(CGFloat yo_multiple))yo_setMultiple
{
    @yo_weakify(self);
    return ^(CGFloat yo_multiple){
        @yo_strongify(self);
        self.yo_multiple = yo_multiple;
        return self;
    };
}

- (void)setYo_multiple:(CGFloat)yo_multiple
{
    _yo_multiple = yo_multiple;
    if (_yo_type & YOImageType) {
        CGPoint center = self.yo_imageView.center;
        self.yo_imageView.yo_setWidth(_yo_imageView.yo_width * yo_multiple).yo_setHeight(_yo_imageView.yo_height * yo_multiple).center = center;
    }
    else if (_yo_type & YOLeftImageType) {
        CGFloat left = self.yo_imageView.yo_left;
        self.yo_imageView.yo_setWidth(_yo_imageView.yo_width * yo_multiple).yo_setHeight(_yo_imageView.yo_height * yo_multiple).yo_setCenterY(self.yo_height / 2.0).yo_left = left;
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        CGFloat right = self.yo_imageView.yo_right;
        self.yo_imageView.yo_setWidth(_yo_imageView.yo_width * yo_multiple).yo_setHeight(_yo_imageView.yo_height * yo_multiple).yo_setCenterY(self.yo_height / 2.0).yo_right = right;
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        CGFloat top = self.yo_imageView.yo_top;
        self.yo_imageView.yo_setWidth(_yo_imageView.yo_width * yo_multiple).yo_setHeight(_yo_imageView.yo_height * yo_multiple).yo_setCenterX(self.yo_width / 2.0).yo_top = top;
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        CGFloat bottom = self.yo_imageView.yo_bottom;
        self.yo_imageView.yo_setWidth(_yo_imageView.yo_width * yo_multiple).yo_setHeight(_yo_imageView.yo_height * yo_multiple).yo_setCenterX(self.yo_width / 2.0).yo_bottom = bottom;
        [self fitBottomTypeLabel];
    }
}

#pragma mark -- ImageSize（绝对大小） --
- (YOButton *(^)(CGSize yo_imageSize))yo_setImageSize
{
    @yo_weakify(self);
    return ^(CGSize yo_imageSize){
        @yo_strongify(self);
        self.yo_imageSize = yo_imageSize;
        return self;
    };
}

- (void)setYo_imageSize:(CGSize)yo_imageSize
{
    _yo_imageSize = yo_imageSize;
    _haveSetSize =  YES;
    if (_yo_type & YOImageType) {
        CGPoint center = self.yo_imageView.center;
        self.yo_imageView.yo_setWidth(yo_imageSize.width).yo_setHeight(yo_imageSize.height).center = center;
    }
    else if (_yo_type & YOLeftImageType) {
        CGFloat left = self.yo_imageView.yo_left;
        self.yo_imageView.yo_setWidth(yo_imageSize.width).yo_setHeight(yo_imageSize.height).yo_setCenterY(self.yo_height / 2.0).yo_left = left;
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        CGFloat right = self.yo_imageView.yo_right;
        self.yo_imageView.yo_setWidth(yo_imageSize.width).yo_setHeight(yo_imageSize.height).yo_setCenterY(self.yo_height / 2.0).yo_right = right;
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        CGFloat top = self.yo_imageView.yo_top;
        self.yo_imageView.yo_setWidth(yo_imageSize.width).yo_setHeight(yo_imageSize.height).yo_setCenterX(self.yo_width / 2.0).yo_top = top;
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        CGFloat bottom = self.yo_imageView.yo_bottom;
        self.yo_imageView.yo_setWidth(yo_imageSize.width).yo_setHeight(yo_imageSize.height).yo_setCenterX(self.yo_width / 2.0).yo_bottom = bottom;
        [self fitBottomTypeLabel];
    }
}

#pragma mark -- 适配文本长度 --
- (YOButton *(^)(BOOL yo_fitTextWidth))yo_setFitTextWidth
{
    @yo_weakify(self);
    return ^(BOOL yo_fitTextWidth){
        @yo_strongify(self);
        self.yo_fitTextWidth = yo_fitTextWidth;
        return self;
    };
}

- (void)setYo_fitTextWidth:(BOOL)yo_fitTextWidth
{
    _yo_fitTextWidth = yo_fitTextWidth;
    if (!yo_fitTextWidth || !self.yo_label.text || self.yo_label.text.length == 0) {
        return;
    }
    
    if (_yo_type & YOTextType) {
        [self.yo_label adaptiveWidth];
        self.yo_setWidth(self.yo_label.yo_right + 5);
        self.yo_label.yo_setCenterX(self.yo_width / 2.0);
    }
    else if (_yo_type & YOLeftImageType) {
        [self.yo_label adaptiveWidth];
        self.yo_setWidth(self.yo_label.yo_right);
    }
    else if (_yo_type & YORightImageType) {
        [self.yo_label adaptiveWidth];
        self.yo_imageView.yo_setLeft(_yo_label.yo_right + FitX(5));
        self.yo_setWidth(_yo_imageView.yo_right);
    }
    else if (_yo_type & YOTopImageType) {
        [self.yo_label adaptiveWidth];
        if (self.yo_label.yo_width > self.yo_width) {
            self.yo_setWidth(self.yo_label.yo_width + 4);
            self.yo_imageView.yo_setCenterX(self.yo_width / 2.0);
        }
        self.yo_label.yo_setCenterX(self.yo_width / 2.0);
    }
    else if (_yo_type & YOBottomImageType) {
        [self.yo_label adaptiveWidth];
        if (self.yo_label.yo_width > self.yo_width) {
            self.yo_setWidth(self.yo_label.yo_width + 4);
            self.yo_imageView.yo_setCenterX(self.yo_width / 2.0);
        }
        self.yo_label.yo_setCenterX(self.yo_width / 2.0);
    }
    else if (_yo_type & YORoundType) {
        [self.yo_label adaptiveWidth];
        self.yo_width = self.yo_label.yo_width + FitX(20);
        self.yo_label.yo_setCenterX(self.yo_width / 2.0);
    }
}

#pragma mark -- 关闭交互 --
- (YOButton *(^)(BOOL yo_unusable))yo_setUnusable
{
    @yo_weakify(self);
    return ^(BOOL yo_unusable){
        @yo_strongify(self);
        self.yo_unusable = yo_unusable;
        return self;
    };
}

- (void)setYo_unusable:(BOOL)yo_unusable
{
    _yo_unusable = yo_unusable;
    if (_yo_type & YORoundType) {
        self.userInteractionEnabled = !yo_unusable;
        if (yo_unusable) {
            self.yo_setBackColor([UIColor grayColor]);
        }
        else {
            self.yo_setBackColor([UIColor orangeColor]);
        }
    }
    else if (_yo_type & YORightRoundType) {
        self.userInteractionEnabled = !yo_unusable;
        if (yo_unusable) {
            self.yo_setBackColor([UIColor grayColor]);
        }
        else {
            self.yo_setBackColor([UIColor blackColor]);
        }
    }
}

#pragma mark -- 设置选中状态 --
- (YOButton *(^)(BOOL yo_select))yo_setSelect
{
    @yo_weakify(self);
    return ^(BOOL yo_select){
        @yo_strongify(self);
        self.yo_select = yo_select;
        return self;
    };
}

- (void)setYo_select:(BOOL)yo_select
{
    _yo_select = yo_select;
    if (_yo_type & YORedLineSelectType) {
        if (yo_select) {
            self.yo_setTextColor(_yo_highlightTextColor).yo_imageView.hidden = NO;
        }
        else {
            self.yo_setTextColor(_yo_normalTextColor).yo_imageView.hidden = YES;
        }
    }
    if (_yo_type & YOSelectType) {
        if (yo_select) {
            self.yo_setTextColor(_yo_highlightTextColor);
        }
        else {
            self.yo_setTextColor(_yo_normalTextColor);
        }
    }
    
}

#pragma mark -- 左间距 LeftSpace --
- (YOButton *(^)(CGFloat yo_leftSpace))yo_setLeftSpace
{
    @yo_weakify(self);
    return ^(CGFloat yo_leftSpace){
        @yo_strongify(self);
        self.yo_leftSpace = yo_leftSpace;
        return self;
    };
}

- (void)setYo_leftSpace:(CGFloat)yo_leftSpace
{
    _yo_leftSpace = yo_leftSpace;
    if (_yo_type & YOImageType) {
        self.yo_imageView.yo_setLeft(yo_leftSpace);
    }
    else if (_yo_type & YOLeftImageType) {
        self.yo_imageView.yo_setLeft(yo_leftSpace);
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        self.yo_label.yo_setLeft(yo_leftSpace).yo_setWidth(self.yo_imageView.yo_left - self.yo_label.yo_left);
    }
    else if (_yo_type & YOTopImageType) {
        self.yo_imageView.yo_setLeft(yo_leftSpace);
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        self.yo_imageView.yo_setLeft(yo_leftSpace);
        [self fitBottomTypeLabel];
    }
    
}


#pragma mark -- 右间距 RightSpace --
- (YOButton *(^)(CGFloat yo_rightSpace))yo_setRightSpace
{
    @yo_weakify(self);
    return ^(CGFloat yo_rightSpace){
        @yo_strongify(self);
        self.yo_rightSpace = yo_rightSpace;
        return self;
    };
}

- (void)setYo_rightSpace:(CGFloat)yo_rightSpace
{
    _yo_rightSpace = yo_rightSpace;
    if (_yo_type & YOImageType) {
        self.yo_imageView.yo_setRight(self.yo_width - yo_rightSpace);
    }
    else if (_yo_type & YOLeftImageType) {
        self.yo_label.yo_setWidth(self.yo_width - yo_rightSpace - _yo_label.yo_left);
    }
    else if (_yo_type & YORightImageType) {
        self.yo_imageView.yo_setRight(self.yo_width - yo_rightSpace);
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        self.yo_imageView.yo_setRight(self.yo_width - yo_rightSpace);
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        self.yo_imageView.yo_setRight(self.yo_width - yo_rightSpace);
        [self fitBottomTypeLabel];
    }
}

#pragma mark -- 顶部间距 TopSpace --
- (YOButton *(^)(CGFloat yo_topSpace))yo_setTopSpace
{
    @yo_weakify(self);
    return ^(CGFloat yo_topSpace){
        @yo_strongify(self);
        self.yo_topSpace = yo_topSpace;
        return self;
    };
}

- (void)setYo_topSpace:(CGFloat)yo_topSpace
{
    _yo_topSpace = yo_topSpace;
    if (_yo_type & YOImageType) {
        self.yo_imageView.yo_setTop(yo_topSpace);
    }
    else if (_yo_type & YOLeftImageType) {
        self.yo_imageView.yo_setTop(yo_topSpace);
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        self.yo_imageView.yo_setTop(yo_topSpace);
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        self.yo_imageView.yo_setTop(yo_topSpace);
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        self.yo_label.yo_setTop(yo_topSpace).yo_setHeight(self.yo_imageView.yo_top - _yo_label.yo_top);
    }

}

#pragma mark -- 底部间距 --
- (YOButton *(^)(CGFloat yo_bottomSpace))yo_setBottomSpace
{
    @yo_weakify(self);
    return ^(CGFloat yo_bottomSpace){
        @yo_strongify(self);
        self.yo_bottomSpace = yo_bottomSpace;
        return self;
    };
}

- (void)setYo_bottomSpace:(CGFloat)yo_bottomSpace
{
    _yo_bottomSpace = yo_bottomSpace;
    if (_yo_type & YOImageType) {
        self.yo_imageView.yo_setBottom(self.yo_height - yo_bottomSpace);
    }
    else if (_yo_type & YOLeftImageType) {
        self.yo_imageView.yo_setBottom(self.yo_height - yo_bottomSpace);
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        self.yo_imageView.yo_setBottom(self.yo_height - yo_bottomSpace);
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        self.yo_label.yo_setHeight(self.yo_height - yo_bottomSpace -_yo_label.yo_top);
    }
    else if (_yo_type & YOBottomImageType) {
        self.yo_imageView.yo_setBottom(self.yo_height - yo_bottomSpace);
        [self fitBottomTypeLabel];
    }

}

#pragma mark -- 图片设置 --
- (YOButton *(^)(UIImage *yo_image))yo_setImage
{
    @yo_weakify(self);
    return ^(UIImage *yo_image){
        @yo_strongify(self);
        self.yo_image = yo_image;
        return self;
    };
}

- (void)setYo_image:(UIImage *)yo_image
{
    if (!yo_image) {
        return;
    }
    _yo_image = yo_image;
    self.yo_imageView.image = yo_image;
    if (self.haveSetSize) {
        return;
    }
    if (_yo_type & YOImageType) {
        CGPoint center = self.yo_imageView.center;
        if (yo_image.size.width >= yo_image.size.height) {
            self.yo_imageView.yo_setWidth(_yo_imageView.yo_height / yo_image.size.height * yo_image.size.width).center = center;
        }
        else {
            self.yo_imageView.yo_setHeight(_yo_imageView.yo_width / yo_image.size.width * yo_image.size.height).center = center;
        }
    }
    else if (_yo_type & YOLeftImageType) {
        CGFloat left = self.yo_imageView.yo_left;
        if (yo_image.size.width >= yo_image.size.height) {
            self.yo_imageView.yo_setWidth(_yo_imageView.yo_height / yo_image.size.height * yo_image.size.width).yo_left = left;
        }
        else {
            self.yo_imageView.yo_setHeight(_yo_imageView.yo_width / yo_image.size.width * yo_image.size.height).yo_left = left;
        }
        [self fitLeftTypeLabel];
    }
    else if (_yo_type & YORightImageType) {
        CGFloat right = self.yo_imageView.yo_right;
        if (yo_image.size.width >= yo_image.size.height) {
            self.yo_imageView.yo_setWidth(_yo_imageView.yo_height / yo_image.size.height * yo_image.size.width).yo_right = right;
        }
        else {
            self.yo_imageView.yo_setHeight(_yo_imageView.yo_width / yo_image.size.width * yo_image.size.height).yo_right = right;
        }
        [self fitRightTypeLabel];
    }
    else if (_yo_type & YOTopImageType) {
        CGFloat top = self.yo_imageView.yo_top;
        if (yo_image.size.width >= yo_image.size.height) {
            self.yo_imageView.yo_setHeight(_yo_imageView.yo_width / yo_image.size.width * yo_image.size.height).yo_top = top;
        }
        else {
            self.yo_imageView.yo_setWidth(_yo_imageView.yo_height / yo_image.size.height * yo_image.size.width).yo_top = top;
        }
        [self fitTopTypeLabel];
    }
    else if (_yo_type & YOBottomImageType) {
        CGFloat bottom = self.yo_imageView.yo_bottom;
        if (yo_image.size.width >= yo_image.size.height) {
            self.yo_imageView.yo_setHeight(_yo_imageView.yo_width / yo_image.size.width * yo_image.size.height).yo_bottom = bottom;
        }
        else {
            self.yo_imageView.yo_setWidth(_yo_imageView.yo_height / yo_image.size.height * yo_image.size.width).yo_bottom = bottom;
        }
        [self fitBottomTypeLabel];
    }
}

#pragma mark -- 设置文本 --
- (YOButton *(^)(NSString *yo_text))yo_setText
{
    @yo_weakify(self);
    return ^(NSString *yo_text){
        @yo_strongify(self);
        self.yo_text = yo_text;
        return self;
    };
}

- (void)setYo_text:(NSString *)yo_text
{
    _yo_text = yo_text;
    self.yo_label.text = yo_text;
    
}


#pragma mark -- BackColor --
- (YOButton *(^)(UIColor *yo_backColor))yo_setBackColor
{
    @yo_weakify(self);
    return ^(UIColor *yo_backColor){
        @yo_strongify(self);
        self.yo_backColor = yo_backColor;
        return self;
    };
}

- (void)setYo_backColor:(UIColor *)yo_backColor
{
    _yo_backColor = yo_backColor;
    [self setBackgroundColor:yo_backColor];
}

#pragma mark -- TextColor --
- (YOButton *(^)(UIColor *yo_textColor))yo_setTextColor
{
    @yo_weakify(self);
    return ^(UIColor *yo_textColor){
        @yo_strongify(self);
        self.yo_textColor = yo_textColor;
        
        return self;
    };
}

- (void)setYo_textColor:(UIColor *)yo_textColor
{
    _yo_textColor = yo_textColor;
    self.yo_label.textColor = yo_textColor;
}

#pragma mark -- 常规状态颜色 --
- (YOButton * _Nonnull (^)(UIColor * _Nonnull))yo_setNormalTextColor
{
    @yo_weakify(self);
    return ^(UIColor *yo_normalTextColor){
        @yo_strongify(self);
        self.yo_normalTextColor = yo_normalTextColor;
        
        return self;
    };
}

- (void)setYo_normalTextColor:(UIColor *)yo_normalTextColor
{
    _yo_normalTextColor = yo_normalTextColor;
}

#pragma mark -- 选中状态颜色 --
- (YOButton * _Nonnull (^)(UIColor * _Nonnull))yo_setHighlightTextColor
{
    @yo_weakify(self);
    return ^(UIColor *yo_highlightTextColor){
        @yo_strongify(self);
        self.yo_highlightTextColor = yo_highlightTextColor;
        
        return self;
    };
}

- (void)setYo_highlightTextColor:(UIColor *)yo_highlightTextColor
{
    _yo_highlightTextColor = yo_highlightTextColor;
}

#pragma mark -- BorderColor --
- (YOButton *(^)(UIColor *yo_borderColor))yo_setBorderColor
{
    @yo_weakify(self);
    return ^(UIColor *yo_borderColor){
        @yo_strongify(self);
        self.yo_borderColor = yo_borderColor;
        return self;
    };
}

- (void)setYo_borderColor:(UIColor *)yo_borderColor
{
    _yo_borderColor = yo_borderColor;
    self.layer.borderColor = yo_borderColor.CGColor;
}

#pragma mark -- Radius --
- (YOButton *(^)(CGFloat yo_radius))yo_setRadius
{
    @yo_weakify(self);
    return ^(CGFloat yo_radius){
        @yo_strongify(self);
        self.yo_radius = yo_radius;
        return self;
    };
}

- (void)setYo_radius:(CGFloat)yo_radius
{
    _yo_radius = yo_radius;
    self.layer.cornerRadius = yo_radius;
}

#pragma mark -- BorderWidth --
- (YOButton *(^)(CGFloat yo_borderWidth))yo_setBorderWidth
{
    @yo_weakify(self);
    return ^(CGFloat yo_borderWidth){
        @yo_strongify(self);
        self.yo_borderWidth = yo_borderWidth;
        return self;
    };
}

- (void)setYo_borderWidth:(CGFloat)yo_borderWidth
{
    _yo_borderWidth = yo_borderWidth;
    self.layer.borderWidth = yo_borderWidth;
}

#pragma mark -- Font --
- (YOButton *(^)(UIFont *yo_font))yo_setFont
{
    @yo_weakify(self);
    return ^(UIFont *yo_font){
        @yo_strongify(self);
        self.yo_font = yo_font;
        return self;
    };
}

- (void)setYo_font:(UIFont *)yo_font
{
    _yo_font = yo_font;
    self.yo_label.font = yo_font;
}

- (UIImageView *)yo_imageView
{
    if (!_yo_imageView) {
        _yo_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_yo_imageView];
    }
    return _yo_imageView;
}

- (UILabel *)yo_label
{
    if (!_yo_label) {
        _yo_label = [[UILabel alloc] initWithFrame:CGRectZero textColor:[UIColor blackColor] font:14 textAlignment:1];
        [self addSubview:_yo_label];
        
    }
    return _yo_label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
