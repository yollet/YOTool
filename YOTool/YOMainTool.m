//
//  YOMainTool.m
//  YOTool
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "YOMainTool.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <WebKit/WebKit.h>

@implementation YOMainTool

+ (YOMainTool *)sharedInstance
{
    static YOMainTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[YOMainTool alloc] init];
    });
    return tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.fitX = [UIScreen mainScreen].bounds.size.width / 375.0;
        self.fitY = [UIScreen mainScreen].bounds.size.height / 667.0;
        
        if ([self isIPad]) {
            self.fitX = [UIScreen mainScreen].bounds.size.width / 1024.0;
            self.fitY = [UIScreen mainScreen].bounds.size.height / 766.0;
        }
        
        self.isX = NO;
        self.topHeight = 0;
        self.bottomHeight = 0;
        
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) {
            self.topHeight = 24;
            self.bottomHeight = 34;
            self.fitY = 1;
            self.isX = YES;
        }
        if ([UIScreen mainScreen].bounds.size.height == 896) {
            self.fitY = _fitX;
        }
    }
    return self;
}

#pragma mark -- 判断是否是手机号 --
- (BOOL)isPhoneNum:(NSString *)phoneNum
{
    NSString *MOBILE = @"^1(3|4|5|6|7|8|9)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
}

#pragma mark -- 字符串高亮系列 --
- (NSMutableAttributedString *)attributedStringWithRang:(NSRange)rang str:(NSString *)str font:(UIFont *)font color:(UIColor *)color
{
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:rang];
    return attributeString;
}

- (NSMutableAttributedString *)getAttStrWithStr:(NSString *)oldStr array:(NSArray *)strArray font:(UIFont *)font textColor:(UIColor *)textColor
{
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc] initWithString:oldStr];
    
    for (int i = 0; i < strArray.count; i ++) {
        NSInteger lenth = [strArray[i] length];
        for (int j = 0; j < oldStr.length - (lenth - 1); j ++) {
            NSString *a = [oldStr substringWithRange:NSMakeRange(j, lenth)];
            if ([a isEqualToString:strArray[i]]) {
                
                [attributeString setAttributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:font,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:NSMakeRange(j, lenth)];
                
            }
        }
    }
    
    return attributeString;
}

- (NSString *)encryptPhoneNum:(NSString *)oldNum index:(NSInteger)index lenth:(NSInteger)lenth
{
    if ([[YOMainTool sharedInstance] isPhoneNum:oldNum]) {
        if (index + lenth > 11) {
            NSLog(@"超出长度限制");
            return oldNum;
        }
        return [oldNum stringByReplacingCharactersInRange:NSMakeRange(index, lenth) withString:@"****"];
    }
    else {
        NSLog(@"不是手机号");
        return oldNum;
    }
}

#pragma mark -- 特殊字符替换字符串中某几位 --
- (NSString *)replaceStr:(NSString *)oldStr withIndex:(NSInteger)index lenth:(NSInteger)lenth encryptStr:(NSString *)encryptStr
{
    if (index + lenth > oldStr.length) {
        NSLog(@"超出字符串范围");
        return oldStr;
    }
    NSMutableString *strs = [NSMutableString string];
    if (encryptStr.length != 1) {
        [strs appendString:encryptStr];
    }
    else {
        for (int i = 0; i < lenth; i ++) {
            [strs appendString:encryptStr];
        }
    }
    return [oldStr stringByReplacingCharactersInRange:NSMakeRange(index, lenth) withString:strs];
}

#pragma mark -- base64加密 --
- (NSString *)base64Str:(NSString *)oldStr
{
    NSData *data = [oldStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

#pragma mark -- MD5加密 --
- (NSString *)md5StrWithOldStr:(NSString *)oldStr
{
    const char *cStr = [oldStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)bigMd5StrWithOldStr:(NSString *)oldStr
{
    const char *cStr = [oldStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

#pragma mark -- 获取顶部viewcontroller --
- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else {
        return vc;
    }
    return nil;
}

#pragma mark -- 去除emjoy --
- (NSString *)converStrEmoji:(NSString *)emojiStr
{
    NSString *tempStr = [[NSString alloc] init];
    NSMutableString *kksstr = [[NSMutableString alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *strMu = [[NSMutableString alloc] init];
    for(int i =0; i < [emojiStr length]; i++)
    {
        tempStr = [emojiStr substringWithRange:NSMakeRange(i, 1)];
        [strMu appendString:tempStr];
        if ([self stringContainsEmoji:strMu]) {
            strMu = [[strMu substringToIndex:([strMu length]-2)] mutableCopy];
            [array removeLastObject];
            continue;
        }else
            [array addObject:tempStr];
    }
    for (NSString *strs in array) {
        [kksstr appendString:strs];
    }
    return kksstr;
}

#pragma mark -- 判断emjoy --
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

#pragma mark -- 获取一个随机颜色 --
- (UIColor *)getRandomColorWithAlpha:(CGFloat)alpha
{
    CGFloat red = arc4random() % 255;
    CGFloat green  = arc4random() % 255;
    CGFloat blue  = arc4random() % 255;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

#pragma mark -- 转化URLEncode --
- (NSString *)getURLEncodeStrWithStr:(NSString *)urlStr
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

#pragma mark -- 时间戳转时间 --
+ (NSString *)timestampToDateFormatter:(NSInteger)timestamp
{
    return [YOMainTool timestampToDateFormatter:timestamp formatterStr:@"yyyy-MM-dd HH:mm"];
}

+ (NSString *)timestampToDateFormatter:(NSInteger)timestamp formatterStr:(NSString *)formatterStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatterStr];
    return [format stringFromDate:date];
}

#pragma mark -- 清理缓存 --
- (void)cleanCache:(CleanCacheBlock _Nullable)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

#pragma mark -- 计算单个文件大小 --
- (long long)fileSizeAtPath:(NSString *)filePath
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]) {
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
    
}

#pragma mark -- 计算整个目录大小 --
- (float)folderSizeAtPath
{
    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager * manager=[NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize / ( 1024.0 * 1024.0 );
}

#pragma mark -- 清除缓存 --
- (void)cleanrCatch
{
    if (@available(iOS 9.0, *)) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma mark -- 获取设备机型 --
- (NSString *)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad (5th generation)";
    
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad (5th generation)";
    
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro (12.9-inch) (2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro (12.9-inch) (2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
    
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    
    if ([platform isEqualToString:@"iPad7,5"])      return @"iPad (6th generation)";
    
    if ([platform isEqualToString:@"iPad7,6"])      return @"iPad (6th generation)";
    
    if ([platform isEqualToString:@"iPad8,1"])      return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,2"])      return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,3"])      return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,5"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    
    if ([platform isEqualToString:@"iPad8,6"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    
    if ([platform isEqualToString:@"iPad8,7"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    
    if ([platform isEqualToString:@"iPad8,8"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    
    if ([platform isEqualToString:@"iPad11,1"])   return @"iPad mini 5";
    
    if ([platform isEqualToString:@"iPad11,2"])   return @"iPad mini 5";
    
    if ([platform isEqualToString:@"iPad11,3"])      return @"iPad Air (3rd generation)";
    
    if ([platform isEqualToString:@"iPad11,4"])      return @"iPad Air (3rd generation)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return platform;
}

#pragma mark -- 判断是不是pad --
- (BOOL)isIPad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
