//
//  NSMutableArray+YOTool.m
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import "NSMutableArray+YOTool.h"

@implementation NSMutableArray (YOTool)

- (void)yoAddObject:(id)anObject
{
    if (!anObject || anObject == nil || anObject == NULL || [anObject isKindOfClass:[NSNull class]]) {
        [self addObject:@""];
    }
    else {
        [self addObject:anObject];
    }
}

@end
