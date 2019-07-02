//
//  PTTPickView.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/6.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
   该框架需要导入 Address.plist PTT_Cities.plist PTT_Provice.plist
 */
@interface PTTPickView : UIView


/**
 根据给定的数据 创建一个PTTPickView

 @param frame        整个视图的frame
 @param firstTitles  第一列标题数组NSArray(NSString*)
 @param firstAction  选中第一列标题触发事件
 @param secondTitles 第二列标题数组NSArray(NSString*) 只有一列数据的话传nil
 @param secondAction 选中第二列标题触发事件  只有一列数据的话传nil
 @param thirdTitles       第三列标题数组NSArray(NSString*)  只有两列数据的话传nil
 @param thirdAction  选中第三列标题触发事件 只有两列数据的话传nil
 @param rowHeight    每行数据高度 传0使用默认高度 40
 @param fontClass    如果有特殊情况需要使用自定义的字体  传入该值,否则传nil使用系统默认字体
 @param fontSize     字体大小
 @param fontColor    字体颜色
 @param linkEnable   当滚动某一列时,后面的子列是否自动滚动至第一列
 @return PTTPickView
 */
-(instancetype)initWithFrame:(CGRect)frame firstsTitles:(NSArray*)firstTitles firstAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))firstAction secondeTitles:(NSArray*)secondTitles secondAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))secondAction thirdTitles:(NSArray*)thirdTitles thirdAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))thirdAction rowHight:(CGFloat)rowHeight fontClass:(id)fontClass fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor linkageEnable:(BOOL)linkEnable;



/**
 根据给定的frame创建一个返回一个年月日选择器 
 选中行列的时候返回一个精确到毫秒的时间戳 支持1970-2038 年

 @param frame frame
 @param rowHeight    行高
 @param fontSize     字体大小
 @param fontColor    字体颜色
 @param action       选中时间行之后执行的Block
        timePickView 当前操作的pickView
        compoent     当前操作的列
        row          当前操作的行
        timeStr      当前对应的时间数据 yyyy年mm月dd日
        timeInterval 当前时间对应的时间戳   毫秒为单位
 @return 时间选择器
 */
-(instancetype)createTimePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *timePickView,long long int compoent,long long int row,NSString *timeStr,long long int timeInterval))action;

/**
   给定一个时间戳 选中时间戳给定的时间  *****时间戳需精确到毫秒,仅在创建完时间选择器之后可用*****

 @param timeStamp 以毫秒为单位的时间戳
 */
-(void)selectTimeWithTimeStamp:(long long int)timeStamp;

/**
 根据给定的年月日,选中对应的日期  *****仅在创建完时间选择器之后可用****

 @param year 年
 @param month 月
 @param day 日
 */
-(void)selectTimeWithYear:(long long int)year month:(long long int)month day:(long long int)day;




/**
 根据给定的frame创建一个返回一个省市县选择器
 
 @param frame frame
 @param rowHeight    行高
 @param fontSize     字体大小
 @param fontColor    字体颜色
 @param action       选中时间行之后执行的Block
   timePickView 当前操作的pickView
   compoent     当前操作的列
   row          当前操作的行
   province     当前选择的省/直辖市
   city         当前选择的市
   county       当前选择的县
 @return 省市县选择器
 */
-(instancetype)createPlacePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *timePickView,long long int compoent,long long int row,NSString *province,NSString *city,NSString *county))action;


/**
 创建葡萄藤专用的地址选择器

 @param frame frame
 @param fontSize     字体大小
 @param fontColor    字体颜色
 @param action       选中时间行之后执行的Block
    pickView    当前操作的pickView
    currentProvince  当前选择省份
    proviceNumber    当前选择省份对应的id
    currentCity      当前选择的城市
    cityNumber       当前选择的城市id
    currentCity      当前选择的区县
    cityNumber       当前选择的区县id
 @return 葡萄藤专用地址选择器
 */
-(instancetype)createPTTPlacePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *pickView,NSString * currentProvince,NSString* proviceNumber,NSString *currentCity,NSString *cityNumber,NSString *currentCounty,NSString *countyNumber))action;

/**
 根据给定的省份Id 和给定的城市id 返回对应的城市名  葡萄藤专用

 @param provinceId 省份id
 @param cityId 城市id
 @return 两个id对应的城市名
 */
+(NSString*)pttCityOfProvinceId:(long long int)provinceId andCityId:(long long int)cityId;

/**
 根据省市县id获取对应的城市信息

 @param provinceId 省id
 @param cityId 城市id
 @param countyid 县id
 @param action 通过回调获取城市信息
 */
+(void)pttGetInfoWithProvinceId:(long long int)provinceId andCityId:(long long int)cityId andCountyId:(long long int)countyId withAction:(void (^)(NSString *provinceName, NSString *cityName,NSString *countyName))action;


/**
 根据给定的省份id和给定的城市id,将选择器选中对应的城市
 处理数据耗时略长,操作将会主副线程间切换

 @param provinceId 省份id
 @param cityId 城市id
 */
-(void)selectPlaceWithProvinceId:(long long int)provinceId andCityId:(long long int)cityId;
@end
