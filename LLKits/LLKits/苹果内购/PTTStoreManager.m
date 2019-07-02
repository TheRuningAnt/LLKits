//
//  VHStoreManager.m
//  VhallIphone
//
//  Created by zhaoguangliang on 16/12/3.
//  Copyright © 2016年 PTT. All rights reserved.
//

#import "PTTStoreManager.h"

#define kSandboxVerifyURL @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL
#define kAppStoreVerifyURL @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证UR
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1
#define REPEAT_VERIFY 10086

@interface PTTStoreManager()<SKRequestDelegate, SKProductsRequestDelegate>

@property (nonatomic,copy)IAPResponsedBlock iAPResponsedBlock;
@property (nonatomic,strong)NSString *  productIdentifier;//当前购买的产品id
@property (nonatomic,assign)NSInteger currentOperationCount;
@property (nonatomic,assign)NSInteger retryCount;
@property (nonatomic,assign)IAPPurchaseStatus status;
@property (nonatomic,strong)NSOperationQueue *netWorkqueue;

@end

@implementation PTTStoreManager

+ (PTTStoreManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PTTStoreManager * storeManagerSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeManagerSharedInstance = [[PTTStoreManager alloc] init];
    });
    return storeManagerSharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}

- (void)removeTransactionObserver
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//购买
-(void)buy:(SKProduct *)product
{    
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction * transaction in transactions)
    {
        NSLog(@"%@ was removed from the payment queue.", transaction.payment.productIdentifier);
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//交易队列回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    NSLog(@"交易队列回调");
    for(SKPaymentTransaction * transaction in transactions)
    {
        switch (transaction.transactionState )
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"\n\n\n\n开始购买");
                self.status = IAPPurchasePurchasing;
                break;
                
            case SKPaymentTransactionStateDeferred:
                //最终状态未确定
                break;
                // The purchase was successful
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"完成购买");
                self.status = IAPPurchaseSucceeded;

                [self completeTransaction:transaction];
                if (_payButton) {
                    
                    _payButton.enabled = YES;
                }
            }
                break;
                // There are restored products
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"恢复购买");
                self.status = IAPPurchasRestored;
            }
                break;
                // The transaction failed
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"购买失败");
                self.status = IAPPurchaseFailed;
                [self completeTransaction:transaction];
                if (_payButton) {
                    
                    _payButton.enabled = YES;
                }
                
                [PTTMaskManager pttRemoveMask];
                [PttLoadingTip stopLoading];
            }
                break;
            default:
                break;
        }
    }
}

//完成整个流程
-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (self.status == IAPPurchaseSucceeded) {

        [self verifyPurchaseWithPaymentTransaction:transaction.transactionIdentifier];
    }
    else
    {
        if (self.iAPResponsedBlock) {
            NSString * errorMessage = [transaction.error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (errorMessage.length==0) {
                errorMessage = @"购买失败";
            }
            self.iAPResponsedBlock(NO,[NSString stringWithFormat:@"%@",errorMessage]);
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


/**
 发起苹果内购
 
 @param productID 购买价格ID
 @param button 点击购买按钮
 @param responsed 购买回调
 */
-(void)buyProductWithPrice:(NSString*)productID actionBtn:(UIButton*)button responsed:(IAPResponsedBlock)responsed{
    
    if (button) {
        _payButton = button;
        _payButton.enabled = NO;
    }
    
    [PTTMaskManager pttAddMaskWithView:nil delegaete:nil];
    [PttLoadingTip startLoading];
    
    NSArray * array = nil;
    
    if (!productID) {
        
        return;
    }
    self.productIdentifier = productID;
    
    array =@[productID];

    if (array && array.count != 0) {
        self.iAPResponsedBlock = responsed;
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:array]];
        request.delegate = self;
        [request start];
    }
}

#pragma mark - SKProductsRequestDelegate

//从AppStore获取产品response
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *productArray = response.products;
    if([productArray count] == 0){
        if (self.iAPResponsedBlock) {
            self.iAPResponsedBlock(NO,@"没有该商品");
        }
        return;
    }

    SKProduct *product = nil;
    for (SKProduct *pro in productArray) {
        if([pro.productIdentifier isEqualToString:self.productIdentifier]){
            product = pro;
            break;
        }
    }
    
    [self buy:product];
}

#pragma mark SKRequestDelegate method

// Called when the product request failed.
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    // Prints the cause of the product request failure
    NSLog(@"Product Request Status: %@",error.localizedDescription);
}

//购买验证
-(void)verifyPurchaseWithPaymentTransaction:(NSString*)transactonId{
    
    
    [PTTMaskManager pttAddMaskWithView:nil delegaete:nil];
    [PttLoadingTip startLoading];
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    if (!receiptString) {
        receiptString = @"";
    }
    WK(weakSelf);
    //保存支付方式及去服务器验证收据是否被使用过
//    [HttpService sendPutHttpRequestWithUrl:API_SavePayType(_oid) paraments:@{@"token":[UserTool userToken]?[UserTool userToken]:@"",@"payWay":@"5"} successBlock:^(NSDictionary *jsonDic) {
//        NSString *calcSign = [PTT_Data_Kit do3DESEncryptStr:[NSString stringWithFormat:@"%lu&%ld",[UserTool userId],weakSelf.orderNo]];
//        //保存支付结果
//        [HttpService sendPutHttpRequestWithUrl:API_SavePayResult(weakSelf.oid) paraments:@{@"token":[UserTool userToken]?[UserTool userToken]:@"",@"result":@"1",@"calcSign":calcSign,@"receiptData":receiptString,@"transactionId":transactonId?transactonId:@""} successBlock:^(NSDictionary *jsonDic) {
//            if (self.iAPResponsedBlock)self.iAPResponsedBlock(YES,@"支付验证成功");
//        } failBlock:^{
//            [PTTMaskManager pttRemoveMask];
//            [PttLoadingTip stopLoading];
//            self.iAPResponsedBlock(NO,@"校验失败");
//        }];
//    }];
    
//    //本地去校验支付订单
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//
//    //创建请求到苹果官方进行购买验证
//    NSURL *url=[NSURL URLWithString:kAppStoreVerifyURL];
//
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//    request.HTTPBody=bodyData;
//    request.HTTPMethod=@"POST";
//    //创建连接并发送同步请求
//    NSError *error=nil;
//    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//
//    //判断当前是什么环境
//    NSString *environment = [dic objectForKey:@"environment"];
//    //如果是沙盒测试环境则将验证切换到沙盒测试环境去验证
//    if ([dic[@"status"] intValue]==21007 || [environment isKindOfClass:[NSNull class]] || [environment isEqualToString:@"Sandbox"] ) {
//
//        [request setURL:[NSURL URLWithString:kSandboxVerifyURL]];
//        responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        if (responseData.length > 0) {
//
//            dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        }
//
//    }
//        if (error) {
//            [PTTMaskManager pttRemoveMask];
//            [PttLoadingTip stopLoading];
//            self.iAPResponsedBlock(NO,@"支付验证失败");
//
//            return;
//        }
//        if([dic[@"status"] intValue]==0){
//
//            if (self.iAPResponsedBlock)
//                self.iAPResponsedBlock(YES,@"支付验证成功");
//            NSLog(@"支付验证成功");
//        }else{
//
//
//            self.iAPResponsedBlock(NO,@"支付验证失败");
//        }
//
//        [PTTMaskManager pttRemoveMask];
//        [PttLoadingTip stopLoading];
//    }
    
//    if (error) {
//               [PTTMaskManager pttRemoveMask];
//                [PttLoadingTip stopLoading];
//        self.iAPResponsedBlock(NO,@"支付验证失败");
//
//        return;
//    }
//    if([dic[@"status"] intValue]==0){
//
//        if (self.iAPResponsedBlock)
//            self.iAPResponsedBlock(YES,@"成功");
//        NSLog(@"支付验证成功");
//    }else{
//
//
//        self.iAPResponsedBlock(NO,@"支付验证失败");
//    }
//
//    [PTTMaskManager pttRemoveMask];
//    [PttLoadingTip stopLoading];
}

#pragma mark 恢复购买过的内容

+(void)restoreHadBuyProduct{ //恢复已经购买过的内容
    
    NSLog(@"开始恢复购买内容");
    
    [PTTMaskManager pttAddMaskWithView:nil delegaete:nil];
    [PttLoadingTip startLoading];
    
    [PTTStoreManager sharedInstance];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

}
//恢复
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"恢复购买失败：%@",error.localizedDescription);
    if (error.code != SKErrorPaymentCancelled)
    {
        self.message = error.localizedDescription;
    }
    
    [PTTShowAlertView showSystemAlsertViewWithTitle:@"提示" message:error.localizedDescription cancleBtnTitle:@"确定" cancelAction:nil sureBtnTitle:nil sureAction:nil viewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    [PTTMaskManager pttRemoveMask];
    [PttLoadingTip stopLoading];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray* purchasedItemIDs = [[NSMutableArray alloc] init];
//    NSLog(@"恢复购买商品数量: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
//    NSLog(@"恢复购买获取到的商品列表 ==== %@",purchasedItemIDs);
//    NSString *jsonStr = [purchasedItemIDs mj_JSONString];
//    
//    [HttpService sendPostHttpRequestWithUrl:API_RestoreShops paraments:@{@"token":[UserTool userToken],@"shopInfo":jsonStr} successBlock:^(NSDictionary *jsonDic) {
//        
//        [PTTShowAlertView showSystemAlsertViewWithTitle:@"提示" message:@"恢复成功" cancleBtnTitle:@"确定" cancelAction:nil sureBtnTitle:nil sureAction:nil viewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//        [PTTMaskManager pttRemoveMask];
//        [PttLoadingTip stopLoading];
//    } failBlock:^{
//        
//        [PTTShowAlertView showSystemAlsertViewWithTitle:@"提示" message:@"恢复失败" cancleBtnTitle:@"确定" cancelAction:nil sureBtnTitle:nil sureAction:nil viewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//        [PTTMaskManager pttRemoveMask];
//        [PttLoadingTip stopLoading];
//    }];
}

@end

