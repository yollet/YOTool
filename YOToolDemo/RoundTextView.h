//
//  RoundTextView.h
//  YOToolDemo
//
//  Created by jhj on 2022/2/23.
//  Copyright © 2022 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundTextView : UIView

@property (nonatomic, strong) NSAttributedString *attStr;
@property (nonatomic, assign) CGFloat radius;

@end

NS_ASSUME_NONNULL_END
