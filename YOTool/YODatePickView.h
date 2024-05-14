//
//  YODatePickView.h
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.

//  日期选择器

#import "YOBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YODatePickBtnBlock)(void);
typedef void(^YODatePickSelectBlock)(NSString *selectDateStr, NSDate *date);

@interface YODatePickView : YOBaseView

@property (nonatomic, strong) UIButton     *leftBtn;
@property (nonatomic, strong) UIButton     *rightBtn;

@property (nonatomic, copy) YODatePickBtnBlock        leftBlock;
@property (nonatomic, copy) YODatePickBtnBlock        rightBlock;

@property (nonatomic, strong) UIView       *bottomView;

@property (nonatomic, strong) UIDatePicker *datePick;
@property (nonatomic, copy) YODatePickSelectBlock dateBlock;

- (instancetype)initDatePickWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
