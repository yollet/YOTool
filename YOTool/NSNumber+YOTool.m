//
//  NSNumber+YOTool.m
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

#import "NSNumber+YOTool.h"

@implementation NSNumber (YOTool)

- (NSString *)integerString
{
    return [NSString stringWithFormat:@"%ld", [self integerValue]];
}

@end
