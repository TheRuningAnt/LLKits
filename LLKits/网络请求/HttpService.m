//
//  HttpService.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService
/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendOriginalGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {

        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger GET:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                successBlock(dict);
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
    }];
}

/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
        
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {

        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger GET:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                 successBlock([dict objectForKey:@"data"]);
            }else{
                [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [PttLoadingTip stopLoading];
    }];
}

/**
 *  发送Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    
    NSString *osType = [paramentsDic objectForKey:@"os"];
    if (osType.length == 0) {
        
        [mutParamatic setValue:KPlat forKey:@"os"];
    }
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger POST:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                successBlock([dict objectForKey:@"data"]);
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"Post请求失败 error = %@",error.description);
    }];
}

/**
 *  发送获取源数据的Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendOriginalPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger POST:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                successBlock(dict);
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Post请求失败 error = %@",error.description);
    }];
}

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  #param failBlock
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }

    [manger POST:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock([dict objectForKey:@"data"]);
        }else{
            
            if (failBlock) {
                failBlock();
            }
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) {
            failBlock();
        }
        NSLog(@"errorr = %@",error);
        
//        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
    }];
}

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  #param failBlock
 */
+(void)sendPostOriginalHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger POST:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock(dict);
        }else{
            
            if (failBlock) {
                failBlock();
            }
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) {
            failBlock();
        }
        NSLog(@"errorr = %@",error);
        
        //        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
    }];
}


/**
 *  发送Get请求  带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {

        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    [manger GET:requestUrl parameters:mutParamatic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                successBlock([dict objectForKey:@"data"]);
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
                if (failBlock) {
                    failBlock();
                }
            }
        }else{
        
            failBlock();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock();
        NSLog(@"%@",error);
    }];
}


/**
 发送Delete请求

 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }

    [manger DELETE:requestUrl parameters:mutParamatic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock([dict objectForKey:@"data"]);
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
//        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
    }];
}

+(void)sendOriginalDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    
    [manger DELETE:requestUrl parameters:mutParamatic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock(dict);
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
           [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
    }];
}

/**
 发送Delete请求 带失败block回调
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failBlock   请求失败回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }

    [manger DELETE:requestUrl parameters:mutParamatic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock([dict objectForKey:@"data"]);
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];        }
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock();
    }];
}


/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KPlat forKey:@"os"];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }

    [manger PUT:requestUrl parameters:mutParamatic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock([dict objectForKey:@"data"]);
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"error == %@",error);
    }];
}

/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failBlock   请求失败回调

 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock  failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }

    [manger PUT:requestUrl parameters:mutParamatic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            successBlock([dict objectForKey:@"data"]);
        }else{
            failBlock();
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock();
    }];
}

/**
  发送上传图片请求

 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param image 需要上传的图片
 @param imageName 上传的图片名
 @param successBlock 请求成功的回调
 */
+(void)sendPostImageHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic image:(UIImage*)image imageName:(NSString*)imageName successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    [manager POST:requestUrl
       parameters:mutParamatic
constructingBodyWithBlock:^(id  _Nonnull formData) {
    
        NSData *data = UIImageJPEGRepresentation(image,0.1);
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"image/jpg"];
    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [PTTMaskManager pttRemoveMask];
        [PttLoadingTip stopLoading];
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
                  
                  successBlock([dict objectForKey:@"data"]);
        }else{
                  
            [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"put image error = %@",error.description);
//        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
    }];
}

/**
 发送上传音频文件请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param file 需要上传的文件
 @param fileName 上传的文件名
 @param successBlock 请求成功的回调
 */
+(void)sendPostAudioHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic file:(NSData*)file fileName:(NSString*)fileName successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *mutParamatic = [[NSMutableDictionary alloc] initWithDictionary:paramentsDic];
    [mutParamatic setValue:KVersion forKey:@"version"];
    [mutParamatic setValue:KPlat forKey:@"os"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    if (deviceToken.length > 0) {
        
        [mutParamatic setValue:deviceToken forKey:@"deviceToken"];
    }
    [manager POST:requestUrl
       parameters:mutParamatic
constructingBodyWithBlock:^(id  _Nonnull formData) {
    
    NSData *data = file;
    [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"audio/mp3"];
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              [PTTMaskManager pttRemoveMask];
              [PttLoadingTip stopLoading];
              
              NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
              if ([[dict objectForKey:@"code"] integerValue] == 0) {
                  
                  successBlock([dict objectForKey:@"data"]);
              }else{
                  
                  [ShowMessageTipUtil showTipLabelWithMessage:[dict objectForKey:@"message"] spacingWithTop:kWindowHeight/4*3 stayTime:2];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              //        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常" spacingWithTop:kWindowHeight/4*3 stayTime:2];
          }];
}


@end
