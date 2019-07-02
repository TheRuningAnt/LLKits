//
//  HttpService.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject

/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendOriginalGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;


/**
 *  发送获取源数据的Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendOriginalPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Get请求  带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 发送Delete请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 发送Delete请求 带失败block回调
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failBlock   请求失败回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 发送原生回调Delete请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendOriginalDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failBlock   请求失败回调
 
 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock  failBlock:(void (^)())failBlock;

/**
 发送上传图片请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param image 需要上传的图片
 @param imageName 上传的图片名
 @param successBlock 请求成功的回调
 */
+(void)sendPostImageHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic image:(UIImage*)image imageName:(NSString*)imageName successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  #param failBlock
 */
+(void)sendPostOriginalHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 发送上传音频文件请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param file 需要上传的文件
 @param fileName 上传的文件名
 @param successBlock 请求成功的回调
 */
+(void)sendPostAudioHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic file:(NSData*)file fileName:(NSString*)fileName successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

@end
