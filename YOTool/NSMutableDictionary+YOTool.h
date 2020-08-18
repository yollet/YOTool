//
//  NSMutableDictionary+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (YOTool)

/**
 去除字典中的null
 */
+ (NSMutableDictionary *)noNullDicWithOldDic:(NSDictionary *)oldDic;

- (void)yoSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
