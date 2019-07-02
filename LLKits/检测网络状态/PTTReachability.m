//
//  PTTReachability.m
//  QeelinMetal-iOS
//
//  Created by 王晨飞 on 16/4/1.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "PTTReachability.h"

@implementation PTTReachability
+(void)PTTReachabilityWithSuccessBlock:(successBlock)success{
    [[self sharedManager]startMonitoring];
    [[self sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==0) {
            success(@"无连接");
        }else if (status ==1){
            success(@"3G/4G网络");
        }else if (status==2){
            success(@"wifi状态下");
        }
    }];

}

@end
