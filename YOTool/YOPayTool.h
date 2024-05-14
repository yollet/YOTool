//
//  YOPayTool.h
//  YOTool
//
//  Created by yollet on 2024/5/10.
//  Copyright © 2024 jhj. All rights reserved.

//  内购

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    YOPurchSuccess = 0,       // 购买成功
    YOPurchFailed = 1,        // 购买失败
    YOPurchCancle = 2,        // 取消购买
    YOPurchVerFailed = 3,     // 订单校验失败
    YOPurchVerSuccess = 4,    // 订单校验成功
    YOPurchNotArrow = 5,      // 不允许内购
    YOPurchPaying = 6,        // 验证完成开始内购
    YOPurchRestored = 7,      // 重复购买
    YOPurchNetworkFailed = 8  // 网络出错
} YOPurchType;

typedef void(^HNCompletionHandle)(YOPurchType type,  id data,  NSString *transactionId);




@interface YOPayTool : NSObject

// 内购标识
@property (nonatomic, strong) NSString *userName;

+ (instancetype)sharePayTool;

- (void)startPurchWithId:(NSString *)purchId orderId:(NSString *)orderId completeHandle:(HNCompletionHandle)handle;

@end

NS_ASSUME_NONNULL_END
