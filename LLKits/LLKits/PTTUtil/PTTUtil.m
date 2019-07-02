//
//  PTTUtil.m
//  CreditCard
//
//  Created by 赵广亮 on 2018/8/2.
//  Copyright © 2018年 zhaoguangliang. All rights reserved.
//

#import "PTTUtil.h"
#import <SAMKeychain.h>
@implementation PTTUtil

/**
 给一个视图切圆角
 
 @param value 圆角值
 @param color 切线颜色
 @param width 切线宽度
 @param view 视图
 */
+(void)clipeLayerWithValue:(CGFloat)value borderColor:(UIColor*)color borderWidth:(CGFloat)width view:(UIView*)view{
    
    if (!view) {
        return;
    }
    
    UIColor *_color = color;
    if (!_color) {
        
        _color = [UIColor clearColor];
    }
    
    CGFloat _width = width;
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = value;
    view.layer.borderColor = _color.CGColor;
    view.layer.borderWidth = _width;
}

/**
 根据图片获取和给定宽度获取图片高度
 
 @param img 图片
 @param width 图片宽度
 @return 图片高度
 */
+(CGFloat)getImgHeigtWihtImg:(UIImage*)img imageWidth:(CGFloat)width{
    
    if (!img) {
        return 0;
    }
    
    CGFloat imageWidth = img.size.width;
    CGFloat imageHeight = img.size.height;
    CGFloat lastImageHeight = imageHeight*(width/imageWidth);
    return lastImageHeight;
}

+ (BOOL)isiPhoneXScreen {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

+ (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

@end
