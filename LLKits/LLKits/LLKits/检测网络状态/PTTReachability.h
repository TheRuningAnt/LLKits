//
//  PTTReachability.h
//  QeelinMetal-iOS
//
//  Created by 王晨飞 on 16/4/1.
//  Copyright © 2016年 董彩丽. All rights reserved.


#import <AFNetworking/AFNetworking.h>

/**
 *  成功回调
 */
typedef void (^successBlock)(NSString * status);


@interface PTTReachability : AFNetworkReachabilityManager

/**
 *  网络状态
 */
+(void)PTTReachabilityWithSuccessBlock:(successBlock)success;

@end
