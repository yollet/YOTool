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
        if ([value isKindOfClass:[NSNull class]] || value == nil) {
            [tempDic setObject:@"" forKey:key];
        }
        else {
            [tempDic setObject:value forKey:key];
        }
    }
    return tempDic;
}

- (void)yoSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!anObject || anObject == nil || anObject == NULL || [anObject isKindOfClass:[NSNull class]]) {
        [self setObject:@"" forKey:aKey];
    }
    else {
        [self setObject:anObject forKey:aKey];
    }
}

@end
