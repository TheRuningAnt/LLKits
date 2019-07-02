//
//  PTTDataKit.m
//  Test_1019
//
//  Created by 赵广亮 on 2016/10/19.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTT_Data_Kit.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "GTMBase64.h"

//密匙 key
#define gkey            @"1765dd8ef64c123456c920fc4554397f"
//偏移量
#define gIv             @"01234567"

@implementation PTT_Data_Kit

/**
 *  给定一个Json格式数据,返回一个初始化好的字典
 *
 *  @param json 数据 (字典/数据块/字符串类型)
 *
 *  @return NSDictionary
 */
+(NSDictionary*)dicionaryWihJSON:(id)json{
    
    if (json == nil || json == (id)kCFNull)return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    }else if([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }else if([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString*)json dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if (![dic isKindOfClass:[NSDictionary class]])dic = nil;
    }
    return dic;
}


/**
 检测手机号格式是否正确
 
 @param phoneNumber 手机号
 @return 返回测试错误原因
 */
+(NSString*)checkphoneNumberForamt:(NSString*)phoneNumber{
    
    //检测是否输入密码
    if (!phoneNumber || phoneNumber.length == 0) {
        
        return @"请输入手机号";
    }
    
    //检测密码格式
    NSString *CM_NUM = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        return @"手机号格式错误";
    }
    
    //检测手机号长度
    if (phoneNumber.length != 11) {
        
        return @"手机号格式错误";
    }
    
    return nil;
}


/**
 检测密码格式是否正确
 
 @param password 密码字符串
 @return 返回测试错误原因
 */
+(NSString*)checkPasswordForamt:(NSString*)password{
    
    //检测是否输入密码
    if (!password || password.length == 0) {
        
        return @"请输入密码";
    }
    
    //检测密码格式
    NSString *CM_NUM = @"^[0-9_a-zA-Z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    if (!isMatch) {
        return @"密码格式错误";
    }
    
    return nil;
}

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @return 字体高度
 */
+(CGFloat)textHeight:(NSString*)str fontSize:(NSInteger)fontSize{//字体默认大小是17
    
    CGRect newRect =   [str boundingRectWithSize:CGSizeMake(kWindowWidth - 60, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return  newRect.size.height;
}

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @param labelWidth
 @return 字体高度
 */
+(CGFloat)textHeight:(NSString*)str  labelWidth:(CGFloat)labelWidth fontSize:(NSInteger)fontSize{
    
    CGRect newRect =   [str boundingRectWithSize:CGSizeMake(labelWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return  newRect.size.height;
}
+(CGFloat)textWidthWithText:(NSString*)text fontSize:(NSInteger)fontSize{
    
    //    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    
    CGSize titleSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    //    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    //    return  rect.size.width;
    return titleSize.width;
}

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @param labelWidth
 @param fontName 字体名
 @return 字体高度
 
 */
+(CGFloat)textHeight:(NSString*)str  labelWidth:(CGFloat)labelWidth fontSize:(NSInteger)fontSize fontName:(NSString*)fontName{
    
    CGRect newRect =   [str boundingRectWithSize:CGSizeMake(labelWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} context:nil];
    return  newRect.size.height;
}

/*
 获取一个随机数 范围在 [from,to]
 */
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(arc4random()%(to-from));
}

+(void)checkNotWorkWithAction:(void (^)(AFNetworkReachabilityStatus state))block{
    
    __weak AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                
                if (block) {
                    block(AFNetworkReachabilityStatusReachableViaWWAN);
                }
                //                [mgr stopMonitoring];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                block(AFNetworkReachabilityStatusReachableViaWiFi);
                //                [mgr stopMonitoring];
            }
                break;
            default:
            {
                block(AFNetworkReachabilityStatusUnknown);
                //                [mgr stopMonitoring];
            }
                ;
                
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}

//去除emoji表情
+ (NSString*)disable_EmojiString:(NSString *)text
{
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return result;
}


/**
 根据系统的状态栏检测网络状态   0  没有网络  1 移动网络  2 WIFI
 */
+(void)checkNetWorkStateWithAppState:(void (^)(NSInteger state))action{
    
//    if ([PTTUtil isiPhoneXScreen]) {
    
        // Allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
        // Set the blocks
        reach.reachableBlock = ^(Reachability*reach)
        {
            // keep in mind this is called on a background thread
            // and if you are updating the UI it needs to happen
            // on the main thread, like this:
            
            NSLog(@"current thread %@",[NSThread currentThread]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(action){
                    
                    if (reach.isReachableViaWiFi) {
                        
                        action(2);
                    }
                    if (reach.isReachableViaWWAN) {
                        
                        action(1);
                    }
                }
                
                [reach stopNotifier];
            });
        };
        
        reach.unreachableBlock = ^(Reachability *reach)
        {
            
            if(action){
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    action(0);
                    [reach stopNotifier];
                });
            }
        };
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [reach startNotifier];
        return;
//    }
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
//    NSString *state = [[NSString alloc]init];
//    int netType = 0;
//    //获取到网络返回码
//    for (id child in children) {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            //获取到状态栏
//            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//        }
//    }
//    
//    if (netType == 5 || netType == 6) { //wifi
//        
//        if(action){
//            
//            action(2);
//        }
//    }else  if (netType == 1 ||netType == 2 ||netType == 3 ) { // 移动网络
//        
//        if(action){
//            
//            action(1);
//        }
//    }else {  //无网络
//        
//        if(action){
//            
//            action(0);
//        }
//    }
}

/**
 推送本地通知
 
 @param titile 通知标题
 @param message 通知详情
 @param delay 延时多久推送
 */
+(void)pushLocalNotificationWithTitle:(NSString*)titile message:(NSString*)message delay:(CGFloat)delay{
    
    NSDate *itemDate = [NSDate date];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate dateByAddingTimeInterval:delay];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    if (message) {
        localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(message, nil)];
    }
    if (titile) {
        localNotif.alertTitle = NSLocalizedString(titile, nil);
    }
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"ID:10" forKey:@"LocalNotification"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

/**
 对字符串进行MD5加密
 
 @param str 测试字符串
 @return 加密结果
 */
+(NSString*)getMD5Str:(NSString*)str{
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 给label设置行距
 
 @param label label对象
 @param lineSpace 行距
 @param text 内容
 @param font 字体
 */
+(void)setLabelSpace:(UILabel*)label withLineSpace:(CGFloat)lineSpace text:(NSString*)text withFont:(UIFont*)font{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    if (!font) {
        
        font = label.font;
    }
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    label.adjustsFontSizeToFitWidth = YES;
    label.attributedText = attributeStr;
}


+(CGFloat)getSpaceLabelHeight:(NSString*)text withLineSpace:(CGFloat)lineSpace withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    if (font) {
        dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(lineSpace)};
    }
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/**
 
 
 @param tableView 需要修改的tableView
 @param action 加载事件
 */
+(void)tableSetAnimationWithTabelView:(UIScrollView*)tableView block:(void (^)())action{
    
    NSMutableArray *idleImages = [NSMutableArray array];
    NSBundle *bundle = [NSBundle mainBundle];
    for (int i = 0; i <= 38; i ++) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"PTT_Top_Loading_%d",i] ofType:@"png"]];
        [idleImages addObject:image];
    }
}

//字符串加密
+(NSString *)do3DESEncryptStr:(NSString *)originalStr{
    
    NSString *ciphertext = nil;
    const char *textBytes = [originalStr UTF8String];
    NSUInteger dataLength = [originalStr length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    const void *iv = (const void *)[gIv UTF8String];
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [gkey UTF8String], kCCKeySize3DES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//字符串解密
+(NSString*)deCodeEncryptStr:(NSString *)encryptStr{
    
    NSData *encryptData = [GTMBase64 decodeData:[encryptStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    
    return result;
}

/**
 将UIView转化为UIImage返回  不失真
 
 @param v 带转化视图
 @return 生成的图片
 */
+(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 生成二维码

 @param text 二维码生成文本
 @return 返回生成好的二维码
 */
+(UIImage*)getQrcodeWithString:(NSString*)text{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *string = text;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    CGFloat size = 300;
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 隐藏名字中间的部分
 
 @param name 名字
 @return 返回值
 */
+(NSString*)hideNameKeyWord:(NSString*)name{
    
    if (!name || name.length == 0) {
        
        return @"";
    }
    
    if (name.length >= 2) {
        
        name = [name substringWithRange:NSMakeRange(0, 1)];
        for (int i = 0; i > name.length - 1; i++ ) {
            
            name = [name stringByAppendingString:@"*"];
        }
    }
    
    return name;
}

/**
 隐藏手机号中间的内容
 
 @param phone 手机号
 @return 隐藏后的返回值
 */
+(NSString*)hidePhoneNumberKeyWord:(NSString*)phone{
    
    
    if (!phone || phone.length <= 7) {
        
        return phone;
    }
    
    phone = [NSString stringWithFormat:@"%@****%@",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(phone.length - 4, 4)]];
    
    return phone;
}


/**
 是否是邮箱验证

 @param email 邮箱地址
 @return 是否是邮箱
 */
+ (BOOL)checkEmail:(NSString *)email{
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
}

/**
 是否是手机验证

 @param phoneNumber 手机号验证
 @return 是否是手机
 */
+ (BOOL)checkPhone:(NSString *)phoneNumber{
    
    NSString *regex = @"^((1[0-9][0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch)
        
    {
        
        return NO;
        
    }
    
    return YES;
}


/**
 校验是否全是数字

 @param str 字符串
 @return 校验结果
 */
+ (BOOL)isNumText:(NSString *)str{
    NSString *regex =@"[0-9]*";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    
    return NO;
}
@end

