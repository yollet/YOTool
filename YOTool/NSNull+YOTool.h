//
//  NSNull+YOTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull (YOTool)

- (NSInteger)integerValue;

- (float)floatValue;

- (NSInteger)length;

- (BOOL)isEqualToString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
