//
//  UIViewController+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "UIViewController+YOTool.h"

@implementation UIViewController (YOTool)

#pragma mark -- Alert相关 --
- (void)showAlertWithTitle:(NSString *_Nullable)title info:(NSString *_Nullable)info leftStr:(NSString *)leftStr rightStr:(NSString *_Nullable)rightStr type:(AlertType)type leftBlock:(void(^_Nullable)(void))leftBlock rightBlock:(void(^_Nullable)(void))rightBlock
{
    if (leftStr == nil && rightStr == nil) {
        return;
    }
    if (title == nil) {
        title = @"提示";
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAct = nil;
    UIAlertAction *rightAct = nil;
    UIAlertActionStyle leftStyle = UIAlertActionStyleDefault;
    UIAlertActionStyle rightStyle = UIAlertActionStyleDefault;
    if (type == leftRedType) {
        leftStyle = UIAlertActionStyleDestructive;
    }
    if (type == rightRedType) {
        rightStyle = UIAlertActionStyleDestructive;
    }
    if (type == allRedType) {
        leftStyle = UIAlertActionStyleDestructive;
        rightStyle = UIAlertActionStyleDestructive;
    }
    if (leftStr) {
        leftAct = [UIAlertAction actionWithTitle:leftStr style:leftStyle handler:^(UIAlertAction * _Nonnull action) {
            if (leftBlock) {
                leftBlock();
            }
        }];
        [alertVC addAction:leftAct];
    }
    
    if (rightStr) {
        rightAct = [UIAlertAction actionWithTitle:rightStr style:rightStyle handler:^(UIAlertAction * _Nonnull action) {
            if (rightBlock) {
                rightBlock();
            }
        }];
        [alertVC addAction:rightAct];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showAlertWithInfo:(NSString *)str
{
    [self showAlertWithTitle:@"提示" info:str leftStr:@"确定" rightStr:nil type:noRedType leftBlock:nil rightBlock:nil];
}

- (void)showAlertWithTitle:(NSString *_Nullable)title info:(NSString *_Nullable)info leftStr:(NSString *)leftStr rightStr:(NSString *_Nullable)rightStr type:(AlertType)type leftBlock:( AlertTextBlock _Nullable)leftBlock rightBlock:(AlertTextBlock _Nullable)rightBlock placeholder:(NSString *_Nullable)placeholder
{
    if (leftStr == nil && rightStr == nil) {
        return;
    }
    if (title == nil) {
        title = @"提示";
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.delegate = self;
    }];
    
    UIAlertAction *leftAct = nil;
    UIAlertAction *rightAct = nil;
    UIAlertActionStyle leftStyle = UIAlertActionStyleDefault;
    UIAlertActionStyle rightStyle = UIAlertActionStyleDefault;
    if (type == leftRedType) {
        leftStyle = UIAlertActionStyleDestructive;
    }
    if (type == rightRedType) {
        rightStyle = UIAlertActionStyleDestructive;
    }
    if (type == allRedType) {
        leftStyle = UIAlertActionStyleDestructive;
        rightStyle = UIAlertActionStyleDestructive;
    }
    if (leftStr) {
        leftAct = [UIAlertAction actionWithTitle:leftStr style:leftStyle handler:^(UIAlertAction * _Nonnull action) {
            if (leftBlock) {
                UITextField *field = [alertVC.textFields firstObject];
                leftBlock(field.text);
            }
        }];
        [alertVC addAction:leftAct];
    }
    
    if (rightStr) {
        rightAct = [UIAlertAction actionWithTitle:rightStr style:rightStyle handler:^(UIAlertAction * _Nonnull action) {
            if (rightBlock) {
                UITextField *field = [alertVC.textFields firstObject];
                rightBlock(field.text);
            }
        }];
        [alertVC addAction:rightAct];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
