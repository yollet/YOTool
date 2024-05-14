//
//  YOTextView.h
//  YOTool
//
//  Created by yollet on 2024/5/14.
//  Copyright © 2024 jhj. All rights reserved.

//  自定义的文本展示器，可以设置最大字数和显示字数

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^YOTextViewReturnBlock)(void);

@interface YOTextView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *mainTextView;
// 上边距
@property (nonatomic, assign) CGFloat topHeight;
// 左边距
@property (nonatomic, assign) CGFloat leftWidth;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, assign) NSInteger maxLength;
// 是否显示字数，默认不显示
@property (nonatomic, assign) BOOL showNum;
@property (nonatomic, copy) YOTextViewReturnBlock returnBlock;
@property (nonatomic, strong) NSString *textViewMaxText;


@end

NS_ASSUME_NONNULL_END
