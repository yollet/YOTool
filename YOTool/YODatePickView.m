
//
//  YODatePickView.m
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import "YODatePickView.h"
#import "YOTool.h"

@implementation YODatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidAction)];
        [self addGestureRecognizer:tap];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _myHeight - _bottomHeight - FitY(222), _myWidth, _bottomHeight + FitY(222))];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(10, 10, FitX(63), FitY(40)) title:@"取消" titleColor:[UIColor colorWithRed:255 / 255.0 green:92 / 255.0 blue:44 / 255.0 alpha:1] backColor:[UIColor clearColor] font:18 radius:0];
        [self.bottomView addSubview:_leftBtn];
        [self.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(_myWidth - 10 - FitX(63), 10, FitX(63), FitY(40)) title:@"确认" titleColor:[UIColor colorWithRed:255 / 255.0 green:92 / 255.0 blue:44 / 255.0 alpha:1] backColor:[UIColor clearColor] font:18 radius:0];
        [self.bottomView addSubview:_rightBtn];
        [self.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initDatePickWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        self.datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.leftBtn.yo_bottom + 10, _myWidth, self.bottomView.yo_height - _bottomHeight - _leftBtn.yo_bottom - 10)];
        
        // 设置时区
        self.datePick.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        //设置日期模式
        self.datePick.datePickerMode = UIDatePickerModeDate;
        // 显示当前时间
        [self.datePick setDate:[NSDate date] animated:NO];
        // 设置最大时间
        [self.datePick setMaximumDate:[NSDate date]];
        
        // 监听滚动
        [self.datePick addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        self.datePick.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:_datePick];
    }
    return self;
}

- (void)leftAction
{
    self.hidden = YES;
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightAction
{
    self.hidden = YES;
    if (self.rightBlock) {
        self.rightBlock();
    }
}

#pragma mark -- date选择 --
- (void)dateChange:(UIDatePicker *)picker
{
    NSDateFormatter *forT = [[NSDateFormatter alloc] init];
    [forT setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [forT stringFromDate:picker.date];
    if (self.dateBlock) {
        self.dateBlock(dateStr, picker.date);
    }
    NSLog(@"日期  %@", dateStr);
}

- (void)hidAction
{
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
