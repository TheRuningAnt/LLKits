//
//  PTTCamerManager.h
//  TestCanmer
//
//  Created by 赵广亮 on 2017/2/18.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 
 iOS7之前都可以访问相机，iOS7之后访问相机有权限设置
 
 将PTTCamerManager定义成全局的变量

 需要在配置文件里添加获取相机请求权限
 <key>NSCameraUsageDescription</key>
	<string>我要用你的相机</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>我要看你相册</string>
 */

typedef NS_ENUM(NSInteger, CameraType){
    
    KCamera_and_album = 0,
    KCamera_only = 1,
    KAlbum_only = 2
};

@interface PTTCamerManager : NSObject

/**
 调用系统相机，并返回获取到的照片

 @param deleageteVC 调用相机的viewController
 @return PTTCamerManager
 */
-(instancetype)initWithVC:(UIViewController*)deleageteVC;

/**
 调用相机方法

 @param cameraType 相机类型
 @param showEditFrame 是否显示图片选取框
 @param action 选取图片之后的action
 */
-(void)callTheCameraWithType:(CameraType)cameraType showEditFrame:(BOOL)showEditFrame aciton:(void (^)(UIImage *image))action;
@end
