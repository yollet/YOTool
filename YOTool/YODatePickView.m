
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
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.yo_width, 0)];
        self.bottomView.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
        [self addSubview:_bottomView];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(10, 10, FitX(63), FitY(40)) title:@"取消" titleColor:[UIColor colorWithRed:255 / 255.0 green:92 / 255.0 blue:44 / 255.0 alpha:1] backColor:[UIColor clearColor] font:18 radius:0];
        [self addSubview:_leftBtn];
        [self.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.bottomView.yo_setHeight(_leftBtn.yo_bottom + 10);
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(_myWidth - 10 - FitX(63), 10, FitX(63), FitY(40)) title:@"确认" titleColor:[UIColor colorWithRed:255 / 255.0 green:92 / 255.0 blue:44 / 255.0 alpha:1] backColor:[UIColor clearColor] font:18 radius:0];
        [self addSubview:_rightBtn];
        [self.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initDatePickWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        self.datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.leftBtn.yo_bottom + 10, self.yo_width, self.yo_height - (_leftBtn.yo_bottom + 10) - _bottomHeight)];
        
        if (@available(iOS 13.4, *)) {
            if (@available(iOS 14.0, *)) {
//                UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
//                    if (mode == UIUserInterfaceStyleDark) {
//                        NSLog(@"深色模式");
//                        self.datePick.backgroundColor = [UIColor blackColor];
//                    } else if (mode == UIUserInterfaceStyleLight) {
//                        NSLog(@"浅色模式");
//                    } else {
//                        NSLog(@"未知模式");
//                    }
                CGFloat height = self.yo_height;
                CGFloat pickHeight = 360 + _bottomHeight;
                CGFloat newHeight = pickHeight + _leftBtn.yo_bottom + 10;
                self.yo_setHeight(newHeight).yo_setTop(self.yo_top - (pickHeight - height));
                self.datePick.yo_setTop(self.leftBtn.yo_bottom + 10).yo_setWidth(320).yo_setHeight(pickHeight).yo_setCenterX(self.yo_width / 2.0);
                self.datePick.preferredDatePickerStyle = UIDatePickerStyleInline;
            } else {
                CGFloat height = self.yo_height;
                CGFloat pickHeight = 270 + _bottomHeight;
                CGFloat newHeight = pickHeight + _leftBtn.yo_bottom + 10;
                self.yo_setHeight(newHeight).yo_setTop(self.yo_top - (pickHeight - height));
                self.datePick.yo_setTop(self.leftBtn.yo_bottom + 10).yo_setWidth(320).yo_setHeight(pickHeight).yo_setCenterX(self.yo_width / 2.0);
                self.datePick.preferredDatePickerStyle = UIDatePickerStyleWheels;
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
            
            
        }
        
        
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
        [self addSubview:_datePick];
        
        
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
