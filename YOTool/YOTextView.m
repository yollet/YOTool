//
//  YOTextView.m
//  YOTool
//
//  Created by yollet on 2024/5/14.
//  Copyright © 2024 jhj. All rights reserved.
//

#import "YOTextView.h"
#import "YOTool.h"

@implementation YOTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mainTextView.font = [UIFont yoSystemFontOfSize:12];
        self.mainTextView.textAlignment = NSTextAlignmentLeft;
        self.mainTextView.textColor = [UIColor lightGrayColor];
        [self addSubview:_mainTextView];
    }
    return self;
}

- (void)setTopHeight:(CGFloat)topHeight
{
    NSAssert(self.yo_height, @"set frame First");
    _topHeight = topHeight;
    self.mainTextView.yo_setLeft(10).yo_setTop(topHeight).yo_setWidth(self.yo_width - 2 * _mainTextView.yo_left).yo_setHeight(self.yo_height - 10 - 17 - 3 - topHeight);
    if (_placeholderLabel) {
        _placeholderLabel.yo_setTop(topHeight);
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero textColor:[UIColor lightGrayColor] font:12 textAlignment:0];
        _placeholderLabel.font = self.mainTextView.font;
        _placeholderLabel.text = placeholder;
        [self addSubview:_placeholderLabel];
        
        _placeholderLabel.yo_setLeft(_mainTextView.yo_left + 5).yo_setTop(_topHeight + 3).yo_setWidth(self.yo_width - 2 * _placeholderLabel.yo_left).yo_setHeight(25);
    }
}

- (void)setLeftWidth:(CGFloat)leftWidth
{
    _leftWidth = leftWidth;
    self.mainTextView.yo_setLeft(leftWidth).yo_setWidth(self.yo_width - 2 * _mainTextView.yo_left);
    if (_numLabel) {
        self.numLabel.yo_setRight(self.yo_width - leftWidth);
    }
    if (_placeholderLabel) {
        self.placeholderLabel.yo_setLeft(_mainTextView.yo_left + 5).yo_setWidth(self.yo_width - 2 * _placeholderLabel.yo_left);
    }
    
}

- (void)setShowNum:(BOOL)showNum
{
    _showNum = showNum;
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero textColor:[UIColor lightGrayColor] font:12 textAlignment:2];
        [self addSubview:_numLabel];
        
        
        
    }
    _numLabel.yo_setWidth(60).yo_setHeight(17).yo_setBottom(self.yo_height - 10).yo_setRight(self.yo_width - _mainTextView.yo_left);
    _numLabel.text = [NSString stringWithFormat:@"0/%ld", _maxLength];
    
    _numLabel.hidden = !showNum;
}

- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    self.mainTextView.delegate = self;
    
}

#pragma mark -- 编辑代理 --
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [self limitMaxLengthWithTextView:textView];
        }
        else {
            
        }
    }
    else {
        [self limitMaxLengthWithTextView:textView];
    }
}

#pragma mark -- 限制字数 --
- (void)limitMaxLengthWithTextView:(UITextView *)textView
{
    if (textView.text.length > self.maxLength) {
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
    if (self.showNum) {
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.length, self.maxLength];
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    NSString *str = [textView.text stringByAppendingString:text];
    if ([text isEqualToString:@""]) {
        if (textView.text.length > 0) {
            str = [textView.text substringToIndex:textView.text.length - 1];
        }
    }
    if (str.length > 0) {
        self.placeholderLabel.hidden = YES;
    }
    else {
        self.placeholderLabel.hidden = NO;
    }
    return YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
