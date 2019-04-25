//
//  YOPickView.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PickBlock)(NSInteger row, NSString *data);

@interface YOPickView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) PickBlock pickBlock;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIButton *hidButton;
@property (nonatomic, strong) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray pickBlock:(PickBlock)block;

@end

NS_ASSUME_NONNULL_END
