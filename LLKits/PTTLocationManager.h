//
//  PTTLocationManager.h
//  TestLocation01_0220
//
//  Created by 赵广亮 on 2017/2/20.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface PTTLocationManager : NSObject

/*
    因为该框架中会回调self，而且回调有可能会根据网络原因出现延迟，所以建议使用application对象
    来持有PTTLocationManager，保证回调的时候不会因为回回调对象被释放而造成应用崩溃
 
    info.plist中，
 
    NSLocationWhenInUseUsageDescription ，允许在前台使用时获取GPS的描述
 
    NSLocationAlwaysUsageDescription ，允许永久使用GPS的描述
 */
/**
 获取当前位置的经纬度

 @param action 经纬度回调block 
    Locatiol    回调的location对象
    latitude    纬度
    longitud    经度
 */
-(void)startWithAction:(void (^)(CLLocation *locatiol,CGFloat latitude,CGFloat longitud))action;

/**
 计算两个经纬度点之间的距离  单位为米
 
 @param latitude1 第一个点的经度
 @param longitude1 第一个点的纬度
 @param latitude2 第二个点的经度
 @param longitude2 第二个点的纬度
 @return 两个点之间的距离
 */
+(double)distanceBetweenOrderByLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double) latitude2 longitude2:(double)longitude2;

/**
 计算B点距离A点的方向
  longitude 经度   latitude纬度

 @param latitudeA A点纬度
 @param longitudeA A点经度
 @param latitudeB B点纬度
 @param longitudeB B点经度
 @return 方向字段 正东 东南..
 */
+(NSString*)directionOfLatitudeA:(CGFloat)latitudeA longitudeA:(CGFloat)longitudeA latitudeB:(CGFloat)latitudeB longitudeB:(CGFloat)longitudeB;
@end
