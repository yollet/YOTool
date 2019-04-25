//
//  YOPickView.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "YOPickView.h"
#import "YOTool.h"

@implementation YOPickView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray pickBlock:(PickBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pickBlock = block;
        self.dataArray = dataArray;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - [YOMainTool sharedInstance].bottomHeight - FitY(250), frame.size.width, FitY(250))];
        pickBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickBackView];
        
        self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, FitY(30), pickBackView.frame.size.width, pickBackView.frame.size.height - FitY(30))];
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.pickView.showsSelectionIndicator = YES;
        [pickBackView addSubview:_pickView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, FitY(30))];
        topView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
        [pickBackView addSubview:topView];
        
        self.hidButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.hidButton.frame = CGRectMake(topView.right - FitX(20) - 50, 0, 50, FitY(30));
        //        [self.hidButton setBackgroundColor:[UIColor cyanColor]];
        [self.hidButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.hidButton setTitleColor:[UIColor colorWithRed:77 / 255.0 green:131 / 255.0 blue:255 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.hidButton addTarget:self action:@selector(hidAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:_hidButton];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickBlock) {
        self.pickBlock(row, _dataArray[row]);
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

- (void)hidAction:(UIButton *)button
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
