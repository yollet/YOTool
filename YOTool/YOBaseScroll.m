//
//  YOBaseScroll.m
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import "YOBaseScroll.h"
#import "YOMainTool.h"

@implementation YOBaseScroll

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myWidth = frame.size.width;
        _myHeight = frame.size.height;
        _topHeight = [YOMainTool sharedInstance].topHeight;
        _bottomHeight = [YOMainTool sharedInstance].bottomHeight;
        _scrollHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
