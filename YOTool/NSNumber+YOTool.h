//
//  NSNumber+YOTool.h
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.

//  NSNumber类扩展

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (YOTool)

- (NSString *)integerString;
- (NSString *)floatString;

// 保留retain位小数, retain:(0~5)
- (NSString *)floatStringWithRetain:(NSInteger)retain;

@end

NS_ASSUME_NONNULL_END
