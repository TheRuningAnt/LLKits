//
//  PTTDataKit.h
//  Test_1019
//
//  Created by 赵广亮 on 2016/10/19.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworkReachabilityManager.h>
#import "CommonCrypto/CommonDigest.h"


@interface PTT_Data_Kit : NSObject

/**
 *  给定一个Json格式数据,返回一个初始化好的字典
 *
 *  @param json 数据 (字典/数据块/字符串类型)
 *
 *  @return NSDictionary
 */
+(NSDictionary*)dicionaryWihJSON:(id)json;

/**
 检测手机号格式是否正确
 
 @param phoneNumber 手机号
 @return 返回测试错误原因
 */
+(NSString*)checkphoneNumberForamt:(NSString*)phoneNumber;

/**
 检测密码格式是否正确

 @param password 密码字符串
 @return 返回测试错误原因
 */
+(NSString*)checkPasswordForamt:(NSString*)password;

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @return 字体高度
 */
+(CGFloat)textHeight:(NSString*)str fontSize:(NSInteger)fontSize;

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @param labelWidth
 @return 字体高度
 */
+(CGFloat)textHeight:(NSString*)str  labelWidth:(CGFloat)labelWidth fontSize:(NSInteger)fontSize;

/**
 计算字体高度代码
 
 @param str 源字体
 @param fontSize 字体大小
 @param labelWidth
 @param fontName 字体名
 @return 字体高度

 */
+(CGFloat)textHeight:(NSString*)str  labelWidth:(CGFloat)labelWidth fontSize:(NSInteger)fontSize fontName:(NSString*)fontName;

/**
 获取字体宽度
 
 @param text 文本内容
 @param fontSize 字体大小
 @return 当前对应字体宽度
 */
+(CGFloat)textWidthWithText:(NSString*)text fontSize:(NSInteger)fontSize;

/*
 获取一个随机数 范围在 [from,to）
 */
+(int)getRandomNumber:(int)from to:(int)to;

//检测网络状态   异步
+(void)checkNotWorkWithAction:(void (^)(AFNetworkReachabilityStatus state))block;

//去除emoji表情
+ (NSString*)disable_EmojiString:(NSString *)text;

/**
 根据系统的状态栏检测网络状态   0  没有网络  1 移动网络  2 WIFI
 */
+(void)checkNetWorkStateWithAppState:(void (^)(NSInteger state))action;

/**
 推送本地通知

 @param titile 通知标题
 @param message 通知详情
 @param delay 延时多久推送
 */
+(void)pushLocalNotificationWithTitle:(NSString*)titile message:(NSString*)message delay:(CGFloat)delay;

/**
 对字符串进行MD5加密

 @param str 测试字符串
 @return 加密结果
 */
+(NSString*)getMD5Str:(NSString*)str;

/**
 给label设置行距

 @param label label对象
 @param lineSpace 行距
 @param text 内容
 @param font 字体
 */
+(void)setLabelSpace:(UILabel*)label withLineSpace:(CGFloat)lineSpace text:(NSString*)text withFont:(UIFont*)font;


/**
 获取带行间距的label高度

 @param text 文本内容
 @param lineSpace 行间距
 @param font 字体
 @param width 文本宽度
 @return 字体高度值
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)text withLineSpace:(CGFloat)lineSpace withFont:(UIFont*)font withWidth:(CGFloat)width ;

/**
 

 @param tableView 需要修改的tableView
 @param action 加载事件
 */
+(void)tableSetAnimationWithTabelView:(UIScrollView*)tableView block:(void (^)())action;

//字符串加密
+(NSString *)do3DESEncryptStr:(NSString *)originalStr;

//字符串解密
+(NSString*)deCodeEncryptStr:(NSString *)encryptStr;

/**
 将UIView转化为UIImage返回  不失真

 @param v 带转化视图
 @return 生成的图片
 */
+(UIImage*)convertViewToImage:(UIView*)v;

/**
 生成二维码
 
 @param text 二维码生成文本
 @return 返回生成好的二维码
 */
+(UIImage*)getQrcodeWithString:(NSString*)text;

/**
 隐藏名字中间的部分

 @param name 名字
 @return 返回值
 */
+(NSString*)hideNameKeyWord:(NSString*)name;

/**
 隐藏手机号中间的内容

 @param phone 手机号
 @return 隐藏后的返回值
 */
+(NSString*)hidePhoneNumberKeyWord:(NSString*)phone;

/**
 是否是手机验证
 
 @param phoneNumber 手机号验证
 @return 是否是手机
 */
+(BOOL)checkPhone:(NSString *)phoneNumber;

/**
 是否是邮箱验证
 
 @param email 邮箱地址
 @return 是否是邮箱
 */
+(BOOL)checkEmail:(NSString *)email;
/**
 校验是否全是数字
 
 @param str 字符串
 @return 校验结果
 */
+ (BOOL)isNumText:(NSString *)str;
@end
