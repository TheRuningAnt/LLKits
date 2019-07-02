//
//  PTTLocationManager.m
//  TestLocation01_0220
//
//  Created by 赵广亮 on 2017/2/20.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import "PTTLocationManager.h"

@interface PTTLocationManager()<CLLocationManagerDelegate>

{
    void (^_action)(CLLocation *Locatiol,CGFloat Latitude,CGFloat Longitud);
}

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation PTTLocationManager

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            _locationManager.distanceFilter = 1.f;
        }
    }
}

/**
 获取当前位置的经纬度
 
 @param action 经纬度回调block
 Locatiol    回调的location对象
 latitude    纬度
 longitud    经度
 */
-(void)startWithAction:(void (^)(CLLocation *locatiol,CGFloat latitude,CGFloat longitud))action{
    
    _action = action;
    [_locationManager startUpdatingLocation];
}

/*
 
 根据经纬度获取城市名
 CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
 [clGeoCoder reverseGeocodeLocation:locatiol completionHandler: ^(NSArray *placemarks,NSError *error) {
 for (CLPlacemark *placeMark in placemarks)
 {
 NSDictionary *addressDic=placeMark.addressDictionary;
 
 NSString *city=[addressDic objectForKey:@"City"];
 weakSelf.addressL.text = city;
 }
 
 }];

 */

/**
 计算两个经纬度点之间的距离  单位为米

 @param latitude1 第一个点的经度
 @param longitude1 第一个点的纬度
 @param latitude2 第二个点的经度
 @param longitude2 第二个点的纬度
 @return 两个点之间的距离
 */
+(double)distanceBetweenOrderByLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double) latitude2 longitude2:(double)longitude2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    
    CLLocationDistance  distance  = [curLocation distanceFromLocation:otherLocation];

    return  distance;
}

/**
 计算B点距离A点的方向
 longitude 经度   latitude纬度
 
 @param latitudeA A点纬度
 @param longitudeA A点经度
 @param latitudeB B点纬度
 @param longitudeB B点经度
 @return 方向字段 正东 东南..
 */
+(NSString*)directionOfLatitudeA:(CGFloat)latitudeA longitudeA:(CGFloat)longitudeA latitudeB:(CGFloat)latitudeB longitudeB:(CGFloat)longitudeB{
    
    NSString *vertical;  //南北
    NSString *horizontal; //东西
    NSString *resDirection;
    
    if (longitudeB > longitudeA) {
        
        horizontal = @"东";
    }else if (longitudeB < longitudeA) {
        
        horizontal = @"西";
    }
    
    if (latitudeB > latitudeA) {
        
        vertical = @"北";
    }else if(latitudeB < latitudeA){
        
        vertical = @"南";
    }
    
    //正 东西
    if (latitudeA == latitudeB) {
        
        if (longitudeB > longitudeA) {
            
            resDirection = @"正东";
        }else if (longitudeB < longitudeA) {
            
            resDirection = @"正西";
        }
    }
    
    //正 南北
    if (longitudeB == longitudeA) {
        
        if (latitudeB > latitudeA) {
            
            resDirection = @"正北";
        }else if (latitudeB > latitudeA) {
            
            resDirection = @"正南";
        }
    }
    
    //原点
    if (latitudeA == latitudeB && longitudeA == longitudeB) {
        
        resDirection = @"原点";
    }
    
    //拼接方向
    if (horizontal && vertical) {
        
        resDirection = [NSString stringWithFormat:@"%@%@",horizontal,vertical];
    }
    
    return resDirection;
}

#pragma mark  delegaete method

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    _action(location,location.coordinate.latitude,location.coordinate.longitude);
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败  error = %@",error);
}

@end
