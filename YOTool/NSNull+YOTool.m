//
//  NSNull+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "NSNull+YOTool.h"

@implementation NSNull (YOTool)

- (NSInteger)integerValue
{
    return 0;
}

- (float)floatValue
{
    return 0;
}

- (NSInteger)length
{
    return 0;
}


- (BOOL)isEqualToString:(NSString *)string
{
    return NO;
}

- (id)objectForKeyedSubscript:(id)data
{
    return [NSNull null];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [NSNull null];
}
  
@end
