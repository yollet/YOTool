//
//  YOBaseCollCell.m
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import "YOBaseCollCell.h"

@implementation YOBaseCollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myWidth = frame.size.width;
        _myHeight = frame.size.height;
    }
    return self;
}

@end
