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

- (NSString *)floatString
{
    return [NSString stringWithFormat:@"%f", [self floatValue]];
}

- (NSString *)floatStringWithRetain:(NSInteger)retain
{
    switch (retain) {
        case 0:
            return [NSString stringWithFormat:@"%.0f", [self floatValue]];
            break;
        case 1:
            return [NSString stringWithFormat:@"%.1f", [self floatValue]];
            break;
        case 2:
            return [NSString stringWithFormat:@"%.2f", [self floatValue]];
            break;
        case 3:
            return [NSString stringWithFormat:@"%.3f", [self floatValue]];
            break;
        case 4:
            return [NSString stringWithFormat:@"%.4f", [self floatValue]];
            break;
        case 5:
            return [NSString stringWithFormat:@"%.5f", [self floatValue]];
            break;
            
        default:
            return [NSString stringWithFormat:@"%f", [self floatValue]];
            break;
    }
    
}



@end
