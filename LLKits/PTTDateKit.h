//
//  PTTDateKit.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
   时间戳和时间字符串转换工具
 */
@interface PTTDateKit : NSObject

/**
  给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
  返回一个yyyy年MM月dd日 格式的字符串

 @param interval 时间戳
 @return yyyy年MM月dd日 格式的字符串
 */
+(NSString*)dateFrom1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd 格式的字符串
 */
+(NSString*)dateLineFormatFrom1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy.MM.dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy.MM.dd 格式的字符串
 */
+(NSString*)datePointFormatFrom1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy/MM/dd 或 昨天  或 HH:SS 格式的字符串
 
 @param interval 时间戳
 @return yyyy/MM/dd 或 昨天  或 HH:SS 格式的字符串
 */
+(NSString*)dateFormatFrom1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy/MM/dd格式的字符串
 
 @param interval 时间戳
 @return yyyy/MM/dd 格式的字符串
 */
+(NSString*)dateFormat2From1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm 格式的字符串
 */
+(NSString*)dateTimeFrom1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm:ss 格式的字符串
 */
+(NSString*)dateTime2From1970WithTimeInterval:(long long int)interval;

/**
 给定一个时间戳 返回由数字组成的字符串 例子 20170304141222 精确到秒  时间戳以毫秒为单位

 @param interval 时间戳
 @return 返回由数字组成的字符串
 */
+(NSString*)dateTimeNumberStrWithTimeInterval:(long long int)interval;

/**
 
 @return 返回由数字组成的字符串
 */
+(NSString*)stringTimerStamp;

/**
 给定一个时间戳 返回改时间戳对应周几

 @param timeStamp 时间戳
 @return 周几名
 */
+(NSString*)weekNameWithTimeStamp:(long long int) timeStamp;

/**
 返回当前的时间,精确到毫秒  格式为 YYYY-MM-dd hh:mm:ss:SSS
 
 @return YYYY-MM-dd hh:mm:ss:SSS  格式的时间字符串
 
 */
+(NSString*)currentDate;

/**
 给定一个yyyy-MM-dd 格式的时间字符串  返回一个标准的时间戳

 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle1String:(NSString*)timeString;

/**
 给定一个yyyy年MM月dd日 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy年MM月dd日 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle2String:(NSString*)timeString;


/**
 给定一个 yyyy-MM-dd HH:mm:ss  格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd HH:mm 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle3String:(NSString*)timeString;

/**
  给定一个时间戳,返回和当前时间戳对应的年龄 (毫秒级的时间戳)

 @param timeStamp 时间戳
 @return 和当前时间对比的年龄
 */
+(long long int)getAgeOfTimeStamp:(int64_t)timeStamp;

/**
 获取当前时间戳 毫秒级
 */
+(long long int)currentTimeStamp;

/**
 给定一个YYYY.MM.DD的日期 返回其对应的时间戳

 @param timeString YYYY.MM.DD 日期字符串
 @return 对应时间戳
 */
+(long long int)getTimeStampWithDatePointString:(NSString*)timeString;

/**
 根据给定的时间戳和月数 返回该月数之后的时间戳  月初对月初 月末对月末

 @param originalTimeSatamp 原时间戳
 @param month 月数
 @return 该月数之后的时间戳
 */
+(long long int)getSpecialTimeStampWithTimeStamp:(long long int)originalTimeSatamp month:(long long int)month;

@end
