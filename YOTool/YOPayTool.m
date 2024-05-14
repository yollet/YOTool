//
//  YOPayTool.m
//  YOTool
//
//  Created by yollet on 2024/5/10.
//  Copyright © 2024 jhj. All rights reserved.
//

#import "YOPayTool.h"
#import <StoreKit/StoreKit.h>

@interface YOPayTool () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

{
    NSString *_purchId;
    HNCompletionHandle _handle;
}

@property (nonatomic, strong) NSString *orderId;

@end

@implementation YOPayTool

#pragma mark -- 单利初始化 --
+ (instancetype)sharePayTool
{
    static YOPayTool *payTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payTool = [[YOPayTool alloc] init];
    });
    return payTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self]; // 购买监听
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark -- 发起购买 --
- (void)startPurchWithId:(NSString *)purchId orderId:(NSString *)orderId completeHandle:(HNCompletionHandle)handle
{
    if (purchId) {
        if ([SKPaymentQueue canMakePayments]) {
            self.orderId = orderId;
            _purchId = purchId;
            _handle = handle;
            NSSet *nsset = [NSSet setWithArray:@[purchId]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }
        else {
            [self handleActionWithType:YOPurchNotArrow data:nil transaction:nil];
        }
    }
}

#pragma mark -- 购买返回码 --
- (void)handleActionWithType:(YOPurchType)type data:(id)data transaction:(SKPaymentTransaction *)transaction
{
    switch (type) {
        case YOPurchPaying:
            NSLog(@"购买中");
            break;
        case YOPurchSuccess:
            NSLog(@"购买成功");
            break;
        case YOPurchFailed:
            NSLog(@"购买失败");
            
            break;
        case YOPurchCancle:
            NSLog(@"用户取消购买");

            break;
        case YOPurchVerFailed:
            NSLog(@"订单校验失败");
            break;
        case YOPurchVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case YOPurchRestored:
            NSLog(@"订单重复购买");
            
            break;
        
        default:
            
            break;
    }
    if(_handle){
        _handle(type,data, transaction ? transaction.transactionIdentifier : @"");
    }
    
}

#pragma mark -- 交易结束 --
- (void)completeTransation:(SKPaymentTransaction *)transation
{
    NSString *product = transation.payment.productIdentifier;
    if ([product length]) {
        // 向自己后台验证购买凭证
    }
    [self verifyPurchaseWithPaymentTransation:transation isTestServer:NO];
}

#pragma mark -- 交易失败 --
- (void)failedTransation:(SKPaymentTransaction *)transation
{
    if (transation.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:YOPurchFailed data:nil transaction:transation];
    }
    else {
        [self handleActionWithType:YOPurchCancle data:nil transaction:transation];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transation];
}

#pragma mark -- 验证交易 --
- (void)verifyPurchaseWithPaymentTransation:(SKPaymentTransaction *)transation isTestServer:(BOOL)flag
{
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    switch (transation.transactionState) {
        case SKPaymentTransactionStatePurchased://交易完成
        {
            NSLog(@"transactionIdentifier = %@", transation.transactionIdentifier);
            // 购买成功将交易凭证发给服务端再次校验
            if (transation.originalTransaction) {
                // 如果是自动续费的订单,originalTransaction会有内容
                NSLog(@"自动续费的订单,originalTransaction = %@",transation.originalTransaction);
            } else {
                // 普通购买，以及第一次购买自动订阅
                NSLog(@"普通购买");
            }
            [self handleActionWithType:YOPurchSuccess data:[receiptData base64EncodedStringWithOptions:0] transaction:transation];
        }
                        break;
                    case SKPaymentTransactionStateFailed://交易失败
            [self handleActionWithType:YOPurchFailed data:nil transaction:transation];
                        break;
                    case SKPaymentTransactionStateRestored://已经购买过该商品
            [self handleActionWithType:YOPurchRestored data:nil transaction:transation];
                        break;
                    case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                        NSLog(@"商品添加进列表");
                        break;
                    default:
            [self handleActionWithType:YOPurchFailed data:nil transaction:transation];
                        break;
    }
    
    
    
    /*
    // 没服务端时自己校验
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data" : [receiptData base64EncodedStringWithOptions:0]
                                      };
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (!jsonRequestData) {
        // 交易凭证为空
        [self handleActionWithType:HNPurchFailed data:nil];
        return;
    }
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt"; // 正式地址
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt"; // 沙盒地址
    }
    NSLog(@"请求地址:%@ 入参:%@", serverString, requestContents);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    [manager POST:serverString parameters:requestContents progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"苹果官网返参 == %@", responseObject);
        if ([responseObject[@"status"] integerValue] == 0) {
            NSLog(@"购买成功");
            NSDictionary *dicReceipt = responseObject[@"receipt"];
            NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
            NSString *productIdentifier = dicInApp[@"product_id"];
            if ([productIdentifier isEqualToString:[HKGlobalTool sharedInstance].proId]) {
                [self handleActionWithType:HNPurchSuccess data:responseObject];
                NSLog(@"处理购买成功业务");
            }
        }
        else if ([responseObject[@"status"] integerValue] == 21007) { // 再次校验
            [self verifyPurchaseWithPaymentTransation:transation isTestServer:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求苹果官方网址校验时出错:%@", error);
        [self handleActionWithType:HNPurchFailed data:nil];
        return;
    }];
     */
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transation];
}

#pragma mark -- 处理字符串 --
- (NSString *)environmentForReceipt:(NSString * )str
{
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray *arr = [str componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString *environment = arr[2];
    return environment;
}

#pragma mark -- 代理 --
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    if ([product count] <= 0) {
        NSLog(@"没有商品");
        [self handleActionWithType:YOPurchFailed data:nil transaction:nil];
        return;
    }
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        if ([pro.productIdentifier isEqualToString:_purchId]) {
            p = pro;
            break;
        }
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"描述:%@",[p description]);
    NSLog(@"创建日期:%@",[p localizedTitle]);
    NSLog(@"本地描述:%@",[p localizedDescription]);
    NSLog(@"价格:%@",[p price]);
    NSLog(@"产品标识:%@",[p productIdentifier]);
    if (@available(iOS 12.2, *)) {
        NSLog(@"产品优惠:%ld",[[p discounts] count]);
    } else {
        // Fallback on earlier versions
    }
    
    NSLog(@"发送购买请求");
    
    [self handleActionWithType:YOPurchPaying data:nil transaction:nil];
    
//    SKPayment *payment = [SKPayment paymentWithProduct:p];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:p];
    payment.applicationUsername = self.userName;

    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -- 请求失败 --
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"请求错误:%@", error);
    [self handleActionWithType:YOPurchNetworkFailed data:nil transaction:nil];
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"反馈信息结束");
}

#pragma mark -- observer --
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased :
                [self completeTransation:tran];
                break;
            case SKPaymentTransactionStatePurchasing :
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored :
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed :
                [self failedTransation:tran];
                break;
            default:
                break;
        }
    }
}


@end
