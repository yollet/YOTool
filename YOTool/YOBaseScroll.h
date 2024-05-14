//
//  YOBaseScroll.h
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YOBaseScroll : UIScrollView

{
    CGFloat _myWidth;
    CGFloat _myHeight;
    CGFloat _topHeight;
    CGFloat _bottomHeight;
    CGFloat _scrollHeight;
}

@end

NS_ASSUME_NONNULL_END
