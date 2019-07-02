//
//  PTTDateKit.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTDateKit.h"

@implementation PTTDateKit

//精确到毫秒时间格式 YYYY-MM-dd hh:mm:ss:SSS

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点)  以毫秒为单位
 返回一个yyyy年MM月dd日 格式的字符串
 
 @param interval 时间戳
 @return yyyy年MM月dd日 格式的字符串
 */
+(NSString*)dateFrom1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSString *str = [formatter stringFromDate:date];
    
    NSArray *dateArray = [str componentsSeparatedByString:@"-"];
    return  [NSString stringWithFormat:@"%@年%@月%@日",dateArray[0],dateArray[1],dateArray[2]];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm 格式的字符串
 */
+(NSString*)dateTimeFrom1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm:ss 格式的字符串
 */
+(NSString*)dateTime2From1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个时间戳 返回由数字组成的字符串 例子 20170304141222 精确到秒  时间戳以毫秒为单位
 
 @param interval 时间戳
 @return 返回由数字组成的字符串
 */
+(NSString*)dateTimeNumberStrWithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSString *timeStr = [formatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",[timeStr substringToIndex:4],[timeStr substringWithRange:NSMakeRange(5, 2)],[timeStr substringWithRange:NSMakeRange(8, 2)],[timeStr substringWithRange:NSMakeRange(11, 2)],[timeStr substringWithRange:NSMakeRange(14, 2)],[timeStr substringWithRange:NSMakeRange(17, 2)]];
}

/**
 给定一个时间戳 返回由数字组成的字符串 例子 20170304141222222 精确到毫秒  时间戳以毫秒为单位
 
 @param interval 时间戳
 @return 返回由数字组成的字符串
 */
+(NSString*)stringTimerStamp{
    
    return [@( [PTTDateKit currentTimeStamp]) stringValue];
}

/**
 给定一个时间戳 返回改时间戳对应周几
 
 @param timeStamp 时间戳
 @return 周几名
 */
+(NSString*)weekNameWithTimeStamp:(long long int) timeStamp{
    
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd 格式的字符串
 */
+(NSString*)dateLineFormatFrom1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy.MM.dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy.MM.dd 格式的字符串
 */
+(NSString*)datePointFormatFrom1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy/MM/dd 或 昨天  或 HH:SS 格式的字符串
 
 @param interval 时间戳
 @return yyyy/MM/dd 或 昨天  或 HH:SS 格式的字符串
 */
+(NSString*)dateFormatFrom1970WithTimeInterval:(long long int)interval{
    
    //获取当前时间戳
    long long int currentTimeStamp = [PTTDateKit currentTimeStamp];
    
    //判断是否为当天
    long long int temp = interval - currentTimeStamp;
    if (temp <= 24 * 60 * 60 * 1000) {
        //当天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
        NSString *result = [formatter stringFromDate:date];
        return [result substringFromIndex:result.length - 5];
    }else if(temp <= 2*24 * 60 * 60 * 1000){
        
        return @"昨天";
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
        return [formatter stringFromDate:date];
    }
}
    
/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy/MM/dd格式的字符串
 
 @param interval 时间戳
 @return yyyy/MM/dd 格式的字符串
 */
+(NSString*)dateFormat2From1970WithTimeInterval:(long long int)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个yyyy-MM-dd 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳  以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle1String:(NSString*)timeString{
    
    if (!timeString) {
        
        return 0;
    }
    
    long long int interval = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    if (dateOfGet) {
        
        interval = [dateOfGet timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 给定一个yyyy年MM月dd日 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy年MM月dd日 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle2String:(NSString*)timeString{
    
    if (!timeString) {
        
        return 0;
    }
    
    long long int interval = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    
    //补上8个小时的时差
    NSDate *dateOfSure = [dateOfGet dateByAddingTimeInterval:8*60*60];
    
    if (dateOfSure) {
        
        interval = [dateOfSure timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 给定一个 yyyy-MM-dd HH:mm:ss  格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd HH:mm 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(long long int)timestampWithYearMonthDayStyle3String:(NSString*)timeString{
    
    if (!timeString) {
        
        return 0;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    //补上8个小时的时差
    NSDate *dateOfSure = [dateOfGet dateByAddingTimeInterval:0];
    
    long long int interval = 0;
    if (dateOfSure) {
        
        interval = [dateOfSure timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 返回当前的时间,精确到毫秒  格式为 YYYY-MM-dd hh:mm:ss:SSS
 
 @return YYYY-MM-dd hh:mm:ss:SSS  格式的时间字符串
 
 */
+(NSString*)currentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    
    NSDate *currentDate = [NSDate date];
    return [formatter stringFromDate:currentDate];
}

/**
 给定一个时间戳,返回和当前时间戳对应的年龄 (毫秒级的时间戳)
 
 @param timeStamp 时间戳
 @return 和当前时间对比的年龄
 */
+(long long int)getAgeOfTimeStamp:(int64_t)timeStamp{
    

    //判断是否是错误数据
    if (timeStamp < 0) {
        return 0;
    }
    
    long long int currentTimeStamp = [[[NSDate alloc] init] timeIntervalSince1970]*1000;
    
    if (currentTimeStamp < timeStamp) {
        
        return 0;
    }

    
    //获取用户的出生年月日格式字符串
    NSString *userAgeStr = [PTTDateKit dateFrom1970WithTimeInterval:timeStamp];
    long long int userYear = [[userAgeStr substringToIndex:4] integerValue];
    long long int userMonth = [[userAgeStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSUInteger userDay = [[userAgeStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    //获取当前年月日格式字符串
    NSString *currentDateStr = [PTTDateKit currentDate];
    long long int currentYear = [[currentDateStr substringToIndex:4] integerValue];
    long long int currentMonth = [[currentDateStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSUInteger currentDay = [[currentDateStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    //计算用户年龄
    int32_t age = (int32_t)(currentYear - userYear);
    if(userMonth >= currentMonth){
        
        if(userMonth > currentMonth){
            
            age --;
        }else{
            
            if(userDay > currentDay){
                
                age--;
            }
        }
    }
    
    if (age < 0) {
        
        return 0;
    }
    
    return age;
}

/**
 获取当前时间戳 毫秒级
 */
+(long long int)currentTimeStamp{
    
    NSDate *date = [NSDate date];
    return [date timeIntervalSince1970]*1000;
}

/**
 给定一个YYYY.MM.DD的日期 返回其对应的时间戳
 
 @param timeString YYYY.MM.DD 日期字符串
 @return 对应时间戳
 */
+(long long int)getTimeStampWithDatePointString:(NSString*)timeString{
    
    
    if (!timeString) {
        
        return 0;
    }
    
    long long int interval = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    if (dateOfGet) {
        
        interval = [dateOfGet timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 根据给定的时间戳和月数 返回该月数之后的时间戳  月初对月初 月末对月末
 
 @param originalTimeSatamp 原时间戳
 @param month 月数
 @return 该月数之后的时间戳
 */
+(long long int)getSpecialTimeStampWithTimeStamp:(long long int)originalTimeSatamp month:(long long int)month{
    
    if (originalTimeSatamp < 0) {
        return 0;
    }
    
    long long int resultYear = 0;
    long long int resultMonth = 0;
    long long int resultDay = 0;
    
    NSString *originalDate = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:originalTimeSatamp];
    
    NSArray *originalDateArr = [originalDate componentsSeparatedByString:@"-"];
    
    long long int originialYear = [originalDateArr[0] integerValue];
    long long int originialMonth = [originalDateArr[1] integerValue];
    long long int originialDay = [originalDateArr[2] integerValue];
    
    //设置年份和月份
    resultYear = originialYear;
    
    if (originialMonth + month > 12) {
        
        if (month <= 12) {
            
            resultYear ++;
            resultMonth = originialMonth + month - 12;
        }else{
            
            resultYear = month/12 + originialYear;
            resultMonth = originialMonth + month % 12;
        }
    }else{
        
        resultYear  = originialYear;
        resultMonth = originialMonth + month;
    }
    
    /*设置天 特殊情况 
     1.2月份 28 29
     2.30 31
    */
    switch (originialDay) {
        case 28:
            
            /*
             判断是2月 -- 判断当前年否是闰年
             1.是闰年  非特殊情况
             2.不是闰年--返回值为下个月月底 判断大小月
             */
            if (originialMonth == 2) {
                
                if(isLeapYear(originialYear)){
                    
                    resultDay = originialDay;
                }else{
                    
                    if (resultMonth == 2) {
                        
                        if (isLeapYear(resultYear)) {
                            
                            resultDay = 29;
                        }else{
                            
                            resultDay = 28;
                        }
                    }else{
                        
                        if (isBigMonth(resultMonth)) {
                            
                            resultDay = 31;
                        }else{
                            
                            resultDay = 30;
                        }
                    }
                }
            }else{
                
                resultDay = originialDay;
            }
            break;
        case 29:
            
            /*
             判断是2月 -- 判断当前年否是闰年
             1.是闰年  非特殊情况
             2.不是闰年--返回值为下个月月底 判断大小月
             */
            if (originialMonth == 2) {
                
                    if (resultMonth == 2) {
                        
                        if (isLeapYear(resultYear)) {
                            
                            resultDay = 29;
                        }else{
                            
                            resultDay = 28;
                        }
                    }else{
                        
                        if (isBigMonth(resultMonth)) {
                            
                            resultDay = 31;
                        }else{
                            
                            resultDay = 30;
                        }
                    }
            }else{
                
                resultDay = originialDay;
            }
            break;
            
        case 30:
            
            /*
             如果当前月是大月  
             1.结果月不是2月 则正常返回
             2.结果月为2月则返回月末
             小月 则返回月末
             
             */
            
            if (isBigMonth(originialMonth)) {
                
                if (resultMonth != 2) {
                    
                    resultDay = originialDay;
                }else{
                    
                    if (isLeapYear(resultYear)) {
                        
                        resultDay = 29;
                    }else{
                        
                        resultDay = 28;
                    }
                }
            }else{
                
                //返回月末
                if (resultMonth == 2) {
                    
                    if (isLeapYear(resultYear)) {
                        
                        resultDay = 29;
                    }else{
                        
                        resultDay = 28;
                    }
                    
                }else{
                 
                    if (isBigMonth(resultMonth)) {
                        
                        resultDay = 31;
                    }else{
                        
                        resultDay = 30;
                    }
                }
            }
            break;
            
        case 31:
            
            /*
            返回月末
             */
            if (resultMonth != 2) {
                
                if (isBigMonth(resultMonth)) {
                    
                    resultDay = 31;
                }else{
                    
                    resultDay = 30;
                }
            }else{
                
                if (isLeapYear(resultYear)) {
                    
                    resultDay = 29;
                }else{
                    
                    resultDay = 28;
                }
            }
            break;
            
        default:
            
            resultDay = originialDay;
            break;
    }
    
    //拼接返回月份
    if (resultYear > 0 && resultMonth > 0 && resultDay > 0) {
        
        NSString *resultDateStr = [NSString stringWithFormat:@"%lu-%lu-%lu",resultYear,resultMonth,resultDay];
        return [PTTDateKit timestampWithYearMonthDayStyle1String:resultDateStr];
    }else{
        
        return 0;
    }
}
    
BOOL isLeapYear(long long int year){
        
    return ((year%4 == 0 && year %100 == 0)||(year%400 == 0));
}

BOOL isBigMonth(long long int month){
    
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        
        return YES;
    }
    
    return NO;
}

@end
