//
//  YOSpeechTool.h
//  YOTool
//
//  Created by yollet on 2024/5/10.
//  Copyright © 2024 jhj. All rights reserved.

//  语音识别

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YOSpeechResultBlock)(NSString *value);

@interface YOSpeechTool : NSObject

@property (nonatomic, copy) YOSpeechResultBlock resultBlock;
@property (nonatomic, assign, readonly) BOOL speeching;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
