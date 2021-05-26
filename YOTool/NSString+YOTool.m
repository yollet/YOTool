//
//  NSString+YOTool.m
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

#import "NSString+YOTool.h"

@implementation NSString (YOTool)

- (NSString *)integerString
{
    return [NSString stringWithFormat:@"%ld", [self integerValue]];
}

@end
