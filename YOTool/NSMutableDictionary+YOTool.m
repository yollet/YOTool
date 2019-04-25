//
//  NSMutableDictionary+YOTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "NSMutableDictionary+YOTool.h"

@implementation NSMutableDictionary (YOTool)

+ (NSMutableDictionary *)noNullDicWithOldDic:(NSDictionary *)oldDic
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *key in oldDic) {
        id value = [oldDic objectForKey:key];
        if ([value isKindOfClass:[NSNull class]]) {
            [tempDic setObject:@"" forKey:key];
        }
        else {
            [tempDic setObject:value forKey:key];
        }
    }
    return tempDic;
}

@end
