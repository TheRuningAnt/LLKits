//
//  PttLoadingTip.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PttLoadingTip : NSObject


/**
   开始加载动画
 */
+(void)startLoading;

/**
 停止并移除动画
 */
+(void)stopLoading;

/**
 *  设置圆圈的中心
 *
 */
+(void)setCenter:(CGPoint)center;


/**
 添加自定义加载动画
 */
+(void)loadWaitingAnimationView;

/**
 移除自定义加载动画
 */
+(void)removeWaitingAnimationView;

@end
