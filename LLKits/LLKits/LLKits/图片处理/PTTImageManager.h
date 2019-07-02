//
//  PTTImageManage.h
//  TestCutImage
//
//  Created by 赵广亮 on 2017/2/17.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PTTImageManager : NSObject

/**
 根据给定的尺寸从原图片切割
 
 @param orinImage 原图片
 @param cutRect 切割范围
 @param centerBool 是否从原图中心开始切割
 @return 切割好的图片
 */
+(UIImage*)cutOrinImage:(UIImage *)orinImage cutRect:(CGRect)cutRect centerBool:(BOOL)centerBool;

//压缩图片,最长边为128
/**
 根据给定的尺寸压缩图片
 
 @param rect 压缩后的大小
 @param img 原图片
 @return 压缩后的图片
 */
+ (UIImage *)scaleToSize:(CGRect)rect withImage:(UIImage *)img;

/**
 降低图片分辨率
 
 @param image 原图片
 @return 降低分辨率之后的图片
 */
+ (UIImage*) transformImageQuality:(UIImage*) image scale:(CGFloat)scale;

/**
 将图片存储到本地并且返回存储的地址（会在Library文件夹下建立独立的文件夹存储图片）

 @param image 需要存储的图片
 @param transform 是否需要降低分辨率
 @return 返回存储地址i
 */
+(NSString*)pttSaveLocalPathOfImage:(UIImage*)image needTransform:(BOOL)transform;

@end
