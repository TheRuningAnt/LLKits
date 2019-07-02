//
//  PTTUtil.h
//  CreditCard
//
//  Created by 赵广亮 on 2018/8/2.
//  Copyright © 2018年 zhaoguangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTUtil : NSObject

/**
 给一个视图切圆角

 @param value 圆角值
 @param color 切线颜色
 @param width 切线宽度
 @param view 视图
 */
+(void)clipeLayerWithValue:(CGFloat)value borderColor:(UIColor*)color borderWidth:(CGFloat)width view:(UIView*)view;

/**
 根据图片获取和给定宽度获取图片高度

 @param img 图片
 @param width 图片宽度
 @return 图片高度
 */
+(CGFloat)getImgHeigtWihtImg:(UIImage*)img imageWidth:(CGFloat)width;


/**
 判断是不是刘海屏幕
 */
+ (BOOL)isiPhoneXScreen;

+ (NSString *)getDeviceId;
@end
