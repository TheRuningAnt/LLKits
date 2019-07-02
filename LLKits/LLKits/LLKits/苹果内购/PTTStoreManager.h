//
//  VHStoreManager.m
//  VhallIphone
//
//  Created by zhaoguangliang on 16/12/3.
//  Copyright © 2016年 PTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, IAPPurchaseStatus)
{
    IAPPurchaseFailed,
    IAPPurchaseSucceeded,
    IAPPurchasePurchasing,
    IAPPurchasRestored,
    IAPPurchasDeferred//最终状态未确定
};

//购买商品类型
typedef NS_ENUM(NSInteger,ProductType){
    
    PTT_Product_Libray,
    PTT_Product_Class,
    PTT_Product_Monthly,
    PTT_Product_Year
};

typedef void(^IAPResponsedBlock)(BOOL isSuccess , NSString * message);

@interface PTTStoreManager : NSObject<SKPaymentTransactionObserver>

@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic,strong) UIButton *payButton;

+ (PTTStoreManager *)sharedInstance;

+(void)restoreHadBuyProduct; //恢复已经购买过的内容

/**
 发起苹果内购
 
 @param productID 购买价格ID
 @param button 点击购买按钮
 @param responsed 购买回调
 */
-(void)buyProductWithPrice:(NSString*)productID actionBtn:(UIButton*)button responsed:(IAPResponsedBlock)responsed;

@end

