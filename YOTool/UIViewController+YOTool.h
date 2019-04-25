//
//  UIViewController+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    noRedType,
    leftRedType,
    rightRedType,
    allRedType
} AlertType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertTextBlock)(NSString *text);

@interface UIViewController (YOTool) <UITextFieldDelegate>

- (void)showAlertWithTitle:(NSString *_Nullable)title info:(NSString *_Nullable)info leftStr:(NSString *)leftStr rightStr:(NSString *_Nullable)rightStr type:(AlertType)type leftBlock:(void(^_Nullable)(void))leftBlock rightBlock:(void(^_Nullable)(void))rightBlock;

- (void)showAlertWithInfo:(NSString *)str;

/**
 有输入框的alert
 */
- (void)showAlertWithTitle:(NSString *_Nullable)title info:(NSString *_Nullable)info leftStr:(NSString *)leftStr rightStr:(NSString *_Nullable)rightStr type:(AlertType)type leftBlock:( AlertTextBlock _Nullable)leftBlock rightBlock:(AlertTextBlock _Nullable)rightBlock placeholder:(NSString *_Nullable)placeholder;

@end

NS_ASSUME_NONNULL_END
