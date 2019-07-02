//
//  PTTImageManage.m
//  TestCutImage
//
//  Created by 赵广亮 on 2017/2/17.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import "PTTImageManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation PTTImageManager


/**
 根据给定的尺寸从原图片切割

 @param orinImage 原图片
 @param cutRect 切割范围
 @param centerBool 是否从原图中心开始切割
 @return 切割好的图片
 */
+(UIImage*)cutOrinImage:(UIImage *)orinImage cutRect:(CGRect)cutRect centerBool:(BOOL)centerBool
{
    
    float orinWidth = orinImage.size.width;
    float orinHeight = orinImage.size.height;
    float resWidth = cutRect.size.width;
    float resHeight = cutRect.size.height;
    CGRect rect;
    
    if(centerBool)
        
        rect = CGRectMake((orinWidth - resWidth)/2, (orinHeight - resHeight)/2, resWidth, resHeight);
    else{
        
        rect = cutRect;
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(orinImage.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

/**
 根据给定的尺寸压缩图片

 @param rect 压缩后的大小
 @param img 原图片
 @return 压缩后的图片
 */
+ (UIImage *)scaleToSize:(CGRect)rect withImage:(UIImage *)img{
    
    //判断图片宽度
    rect =CGRectMake(0,0, rect.size.width,rect.size.height);
    
    CGSize size = rect.size;
    UIGraphicsBeginImageContext(size);
    [img drawInRect:rect];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(scaledImage,nil, nil, nil);
    
    return scaledImage;
}

/**
 降低图片分辨率

 @param image 原图片
 @return 降低分辨率之后的图片
 */
+ (UIImage*) transformImageQuality:(UIImage*) image scale:(CGFloat)scale{
    
    NSData *data = UIImageJPEGRepresentation(image,scale);
    return [UIImage imageWithData:data];
}

void ProviderReleaseDataa (void *info,const void *data,size_t size)
{
    free((void*)data);
}

static NSString *imageFolder = nil;
/**
 将图片存储到本地并且返回存储的地址（会在Library文件夹下建立独立的文件夹存储图片）
 
 @param image 需要存储的图片
 @param transform 是否需要降低分辨率
 @return 返回存储地址i
 */
+(NSString*)pttSaveLocalPathOfImage:(UIImage*)image needTransform:(BOOL)transform{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //创建缓存图片文件夹
    if (!imageFolder) {
        
        imageFolder = [NSString stringWithFormat:@"%@/PTTImage1",documentPath];
        if (![fileManager fileExistsAtPath:imageFolder]) {
            
            [fileManager createDirectoryAtPath:imageFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //判断是否需要降低分辨率
    if (transform) {

       image = [PTTImageManager transformImageQuality:image scale:0.1];
    }
    
    //将图片转为Data保存在本地 获取当前时间戳
    long long int currentTimeStamp = [[[NSDate alloc] init] timeIntervalSince1970]*1000;
    NSString *imageSavePath = [NSString stringWithFormat:@"%@/%lld.png",imageFolder,currentTimeStamp];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if ([fileManager fileExistsAtPath:imageSavePath]) {
        
        [fileManager removeItemAtPath:imageSavePath error:nil];
    }
    
    BOOL res =  [imageData writeToFile:imageSavePath atomically:YES];
    if(res){
        
        return [NSString stringWithFormat:@"%@/%lld.png",[imageFolder lastPathComponent],currentTimeStamp];
    }else{
        
        NSLog(@"图片存储失败 %s",__func__);
        return nil;
    }
}

@end
