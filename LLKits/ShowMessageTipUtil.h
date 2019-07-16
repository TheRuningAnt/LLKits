//
//  UILabel+MessageTip.h
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2016/10/11.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMessageTipUtil : NSObject

/**
 根据给定的属性设置弹出框

 @param message 消息内容
 */
+(void)showTipLabelWithMessage:(NSString*)message;

/**
 根据给定的属性设置弹出框
 
 @param message 消息内容
 @param topSpace 距离屏幕顶部的距离
 @param stayTime 在页面停留时间
 */
+(void)showTipLabelWithMessage:(NSString*)message spacingWithTop:(CGFloat)topSpace stayTime:(CGFloat)stayTime;

@end
