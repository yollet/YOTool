//
//  YOMainTool.h
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CleanCacheBlock)(void);

@interface YOMainTool : NSObject

@property (nonatomic, assign) CGFloat fitX;
@property (nonatomic, assign) CGFloat fitY;
@property (nonatomic, assign) BOOL isX;
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat bottomHeight;

+ (YOMainTool *)sharedInstance;

/**
 字符串高亮(Rang)
 */
- (NSMutableAttributedString *)attributedStringWithRang:(NSRange)rang str:(NSString *)str font:(UIFont *)font color:(UIColor *)color;

/**
 字符串高亮(识别某些字段)
 strArray:需要高亮的字符 例:@[@"2", @"223"];
 */
- (NSMutableAttributedString *)getAttStrWithStr:(NSString *)oldStr array:(NSArray *)strArray font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 判断是否是手机号
 */
- (BOOL)isPhoneNum:(NSString *)phoneNum;

/**
 手机号中间加密
 */
- (NSString *)encryptPhoneNum:(NSString *)oldNum index:(NSInteger)index lenth:(NSInteger)lenth;

/**
 用特殊符号替换字符串
 oldStr:需要替换的字符串
 index:从第几个字符开始替换
 lenth:替换的长度
 encryptStr:替换字符串 传单个字符时根据lenth重复字符再替换 传字符串时直接替换
 */
- (NSString *)replaceStr:(NSString *)oldStr withIndex:(NSInteger)index lenth:(NSInteger)lenth encryptStr:(NSString *)encryptStr;

/**
 base64加密
 */
- (NSString *)base64Str:(NSString *)oldStr;

/**
 md5加密
 */
- (NSString *)md5StrWithOldStr:(NSString *)oldStr;
- (NSString *)bigMd5StrWithOldStr:(NSString *)oldStr;

/**
 获取顶部viewcontroller
 */
- (UIViewController *)topViewController;

/**
 去除字符串中的emjoy
 */
- (NSString *)converStrEmoji:(NSString *)emojiStr;

/**
 获取一个随机颜色（rgb）
 */
 - (UIColor *)getRandomColorWithAlpha:(CGFloat)alpha;

/**
 URLEncode编码 去除特殊字符
 */
- (NSString *)getURLEncodeStrWithStr:(NSString *)urlStr;

/**
 获取设备机型
 */
- (NSString *)deviceVersion;

/**
 时间戳转时间 (yyyy-MM-dd HH:mm)
 */
+ (NSString *)timestampToDateFormatter:(NSInteger)timestamp;

/**
 清除缓存
 */
- (void)cleanCache:(CleanCacheBlock _Nullable)block;

/**
 *  整个缓存目录的大小
 */
- (float)folderSizeAtPath;

/**
 清除WKWeb缓存
 */
- (void)cleanrCatch;

@end

NS_ASSUME_NONNULL_END
