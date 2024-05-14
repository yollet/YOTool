//
//  YOBaseField.m
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

#import "YOBaseField.h"
#import <YOTool/YOTool.h>

@implementation YOBaseField

- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    self.delegate = self;
}

- (void)setShowNum:(BOOL)showNum
{
    _showNum = showNum;
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero textColor:[UIColor colorWithRed:146 / 255.0 green:146 / 255.0 blue:146 / 255.0 alpha:1] font:12 textAlignment:2];
        [self addSubview:_numLabel];
        
        _numLabel.yo_setWidth(40).yo_setHeight(17).yo_setCenterY(self.yo_height / 2.0).yo_setRight(self.yo_width - 5);
        _numLabel.text = [NSString stringWithFormat:@"0/%ld", _maxLength];
    }
    
    _numLabel.hidden = !showNum;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.returnBlock) {
        return self.returnBlock();
    }
    else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    YOBaseField *field = (YOBaseField *)textField;
    if (!field.maxLength || field.maxLength == 0) {
        return YES;
    }
    NSString *fieldText = [NSString stringWithFormat:@"%@%@", field.text, string];
    if ([string isEqualToString:@""]) {
        if (fieldText.length > 1) {
            fieldText = [fieldText substringToIndex:fieldText.length - 1];
        }
    }
    
    if (fieldText.length <= field.maxLength) {
        if (self.changeBlock) {
            self.changeBlock(fieldText);
        }
        if (field.showNum) {
            field.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", fieldText.length, field.maxLength];
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setLeftWidth:(CGFloat)leftWidth
{
    _leftWidth = leftWidth;
    if (!self.leftView) {
        self.leftView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    self.leftView.yo_setTop(0).yo_setLeft(0).yo_setWidth(leftWidth).yo_setHeight(self.yo_height);
    self.leftViewMode = UITextFieldViewModeAlways;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
