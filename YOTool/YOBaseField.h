//
//  YOBaseField.h
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.

//  增加字数限制和显示文本字数

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^YOFieldReturnBlock)(void);
typedef void(^YOFieldTextChangeBlock)(NSString *text);

@interface YOBaseField : UITextField <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) BOOL showNum;
@property (nonatomic, copy) YOFieldReturnBlock returnBlock;
@property (nonatomic, copy) YOFieldTextChangeBlock changeBlock;
@property (nonatomic, assign) CGFloat leftWidth;

@end

NS_ASSUME_NONNULL_END
