//
//  YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YOTool.h"
#import "YOMainTool.h"
#import "UIFont+YOTool.h"
#import "NSDictionary+YOLogTool.h"
#import "UIImage+YOTool.h"
#import "UIViewController+YOTool.h"
#import "NSMutableDictionary+YOTool.h"
#import "NSNull+YOTool.h"
#import "UILabel+YOTool.h"
#import "UITextField+YOTool.h"
#import "UIButton+YOTool.h"
#import "YOPickView.h"
#import "YOBaseView.h"
#import "YOBaseScroll.h"
#import "YOBaseCell.h"
#import "YOBaseCollCell.h"
#import "NSMutableArray+YOTool.h"
#import "YOBaseField.h"
#import "NSString+YOTool.h"
#import "NSNumber+YOTool.h"
#import "YODatePickView.h"
#import "YOLocationTool.h"
#import "YOCollectionFlowLayout.h"
#import "YORoundProgressView.h"
#import "YORoundExerciseProgress.h"
#import "YORoundTextView.h"
#import "YOSpeechTool.h"
#import "YOButton.h"
#import "YOSoundPlayTool.h"
#import "YOTextView.h"
#import "YOProgressView.h"

typedef void(^YOIntegerBlock)(NSInteger tag);
typedef void(^YOVoidBlock)(void);
typedef void(^YOFloatBlock)(CGFloat value);
typedef void(^YOBoolBlock)(BOOL value);
typedef void(^YOStringBlock)(NSString *value);
typedef void(^YODicBlock)(NSDictionary *value);
typedef void(^YOArrayBlock)(NSArray *value);

CG_INLINE CGFloat FitX(CGFloat a)
{
    return round([YOMainTool sharedInstance].fitX * a);
}

CG_INLINE CGFloat FitY(CGFloat a)
{
    return round([YOMainTool sharedInstance].fitY * a);
}

CG_INLINE CGRect
YORectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = FitX(x); rect.origin.y = FitY(y);
    rect.size.width = FitX(width); rect.size.height = FitY(height);
    return rect;
}

//! Project version number for YOTool.
FOUNDATION_EXPORT double YOToolVersionNumber;

//! Project version string for YOTool.
FOUNDATION_EXPORT const unsigned char YOToolVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <YOTool/PublicHeader.h>


