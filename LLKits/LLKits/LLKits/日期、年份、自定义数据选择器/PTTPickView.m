//
//  PTTPickView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/6.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTPickView.h"
#import "PTTDateKit.h"
#define WK(weakSelf) __weak typeof (self) weakSelf = self;

@interface PTTPickView()<UIPickerViewDataSource,UIPickerViewDelegate>

{
@private
    
    NSArray *_firstTitles;
    NSArray *_secondTitles;
    NSArray *_thirdTitles;
    
    void (^_firstAction)(UIPickerView* pickView,long long int compoent,long long int row);
    void (^_senondAction)(UIPickerView* pickView,long long int compoent,long long int row);
    void (^_thirdAction)(UIPickerView* pickView,long long int compoent,long long int row);
    
    UIFont *_fontClass;
    CGFloat _fontSize;
    UIColor *_fontColor;
    
    CGFloat _rowHeight;
    long long int _numberOfComponent;
    BOOL _linkEnable;
    
    //时间选择器数据
    
    NSMutableArray *_years;
    NSMutableArray *_months;
    NSMutableArray *_days;
    
    __block long long int _currentTimeStamp;
    __block long long int _lastYearIndex;
    __block long long int _lastMonthIndex;
    __block long long int _lastDayIndex;
    
    //年月日选择器数据

    __block NSString * _lastProvince;
    __block NSString * _lastCity;
    __block NSString * _lastCounty;
    
    //中国省份选择器
    NSDictionary *_chinaPlaceDic;
    __block NSMutableArray *_provinces;
    __block NSMutableArray *_citys;
    __block NSMutableArray *_countys;
    
    //葡萄藤地址选择器数据
    NSDictionary *_pttProvinceRootDic;
    NSDictionary *_pttCitiesRootDic;
    NSDictionary *_pttCountiesRootDic;
    
    NSDictionary *_pttCurrentCityDic;
    
    NSMutableArray *_pttProvinces;
    NSMutableArray *_pttCurrentCities;
    NSMutableArray *_pttCurrentCounties;
    NSString *_pttCurrentCity;
    NSString *_pttCurrentProvince;
    NSString *_pttCurrentCounty;

}

@property (nonatomic,strong) UIPickerView *pickView;

@end

@implementation PTTPickView

/**
 根据给定的数据 创建一个PTTPickView
 
 @param frame 整个视图的frame
 @param firstTitles 第一列标题数组NSArray(NSString*)
 @param firstAction 选中第一列标题触发事件
 @param secondTitles 第二列标题数组NSArray(NSString*) 只有一列数据的话传nil
 @param secondAction 选中第二列标题触发事件  只有一列数据的话传nil
 @param titles 第三列标题数组NSArray(NSString*)  只有两列数据的话传nil
 @param thirdAction 选中第三列标题触发事件 只有两列数据的话传nil
 @param rowHeight 每行数据高度 传0使用默认高度 40
 @param fontClass 如果有特殊情况需要使用自定义的字体  传入该值,否则传nil使用系统默认字体
 @param fontSize 字体大小
 @param fontColor 字体颜色
 @param linkEnable 当滚动某一列时,后面的子列是否自动滚动至第一列
 @return PTTPickView
 */
-(instancetype)initWithFrame:(CGRect)frame firstsTitles:(NSArray*)firstTitles firstAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))firstAction secondeTitles:(NSArray*)secondTitles secondAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))secondAction thirdTitles:(NSArray*)thirdTitles thirdAction:(void (^)(UIPickerView* pickView,long long int compoent,long long int row))thirdAction rowHight:(CGFloat)rowHeight fontClass:(id)fontClass fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor linkageEnable:(BOOL)linkEnable{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //获取标题数据
        _firstTitles = firstTitles;
        _secondTitles = secondTitles;
        _thirdTitles = thirdTitles;
        
        //获取事件
        _firstAction = firstAction;
        _senondAction = secondAction;
        _thirdAction = thirdAction;
        
        //获取字体属性
        _fontClass = fontClass;
        _fontSize = fontSize;
        _fontColor = fontColor;
        
        _numberOfComponent = 0;
        if (firstTitles) {
            _numberOfComponent ++;
        }
        if (secondTitles) {
            _numberOfComponent ++;
        }
        if (thirdTitles) {
            _numberOfComponent ++;
        }
        
        //是否需要联动
        _linkEnable = linkEnable;
    }
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickView];
    
    return self;
}

/**
 根据给定的frame创建一个返回一个年月日选择器
 选中行列的时候返回一个精确到毫秒的时间戳 支持1970-2038 年
 
 @param frame frame
 @param rowHeight    行高
 @param fontSize     字体大小
 @param fontColor    字体颜色
 @param action       选中时间行之后执行的Block,每次选择完时间之后都会回调该action
 timePickView 当前操作的pickView
 compoent     当前操作的列
 row          当前操作的行
 timeInterval 当前时间对应的时间戳   毫秒为单位
 @return 时间选择器
 */
-(instancetype)createTimePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *timePickView,long long int compoent,long long int row,NSString *timeStr,long long int timeInterval))action{
    
    _years = [NSMutableArray array];
    int year = 2016;
    for(int i = 0; i < 40; i ++){
        
        NSString *strOfYear = [NSString stringWithFormat:@"%d年",year ++];
        [_years addObject:strOfYear];
    }
    
    _months = [NSMutableArray array];
    int month = 1;
    for(int i = 0; i < 12; i ++){
        
        NSString *strOfMonth = [NSString stringWithFormat:@"%d月",month ++];
        [_months addObject:strOfMonth];
    }
    
    _days = [NSMutableArray array];
    int day = 1;
    for(int i = 0; i < 31; i ++){
        
        NSString *strOfDay = [NSString stringWithFormat:@"%d日",day ++];
        [_days addObject:strOfDay];
    }
    
    //初始化默认数据,默认显示今天之后的日期
    _lastYearIndex = 0;
    _lastMonthIndex = 0;
    _lastDayIndex = 0;
    
    WK(weakSelf);
    id res = [self initWithFrame:frame firstsTitles:_years
                     firstAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         _lastYearIndex = row;
                         
                         //根据年份和月份来调整days的数目
                         long long int year = [[_years[_lastYearIndex] substringToIndex:4] integerValue];
                         long long int month = _lastMonthIndex + 1;
                         
                         //如果是闰年 则2月有29天 否则2月有28天
                         if ((year%4==0 && year%100!=0) || year%400 ==0){
                             
                             if (month == 2) {
                                 
                                 long long int daysCount = _days.count ;
                                 //若上个月份的天数大于29则移除多余的天数
                                 while (_days.count > 29) {
                                     [_days removeLastObject];
                                 }
                                 
                                 //若上个月的天数小于29则添加天数
                                 while (_days.count < 29) {
                                     
                                     [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
                                 }
                             }
                         }else{
                             
                             if (month == 2) {
                                 
                                 long long int daysCount = _days.count ;
                                 //若上个月份的天数大于28则移除多余的天数
                                 while (_days.count > 28) {
                                     [_days removeLastObject];
                                 }
                                 
                                 //若上个月的天数小于28则添加天数
                                 while (_days.count < 28) {
                                     
                                     [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
                                 }

                             }
                         }
                         
                         //1 3 5 7 8 10 12 月份  31天
                         if (month == 1 ||month == 3 ||month == 5 ||month == 7 ||month == 8 ||month == 10 ||month == 12) {
                             
                             while (_days.count < 31) {
                                 
                                 long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                                 [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
                             }
                         }
                         if (month == 4 ||month == 6 ||month == 9 ||month == 11) {
                             
                             if (_days.count == 31) {
                                 [_days removeLastObject];
                             }else{
                                 
                                 while (_days.count < 30) {
                                     
                                     long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                                     [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
                                 }
                             }
                         }
                         
                         
                         [weakSelf.pickView reloadComponent:2];
                         
                         //根据更新完的控件更新时间戳
                         if (_lastDayIndex == _days.count) {
                             _lastDayIndex --;
                         }
                         NSString *timeStr = [NSString stringWithFormat:@"%@%@%@",_years[_lastYearIndex],_months[_lastMonthIndex],_days[_lastDayIndex]];
                         _currentTimeStamp = [PTTDateKit timestampWithYearMonthDayStyle2String:timeStr];
                         
                         //回调方法
                         action(weakSelf.pickView,compoent,row,timeStr,_currentTimeStamp);
                     } secondeTitles:_months
                    secondAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                        
                        _lastMonthIndex = row;
                        
                        //根据年份和月份来调整days的数目
                        long long int year = [[_years[_lastYearIndex] substringToIndex:4] integerValue];
                        long long int month = _lastMonthIndex + 1;
                        
                        //如果是闰年 则2月有29天 否则2月有28天
                        if ((year%4==0 && year%100!=0) || year%400 ==0){
                            
                            if (month == 2) {
                                
                                long long int daysCount = _days.count ;
                                //若上个月份的天数大于29则移除多余的天数
                                while (_days.count > 29) {
                                    [_days removeLastObject];
                                }
                                
                                //若上个月的天数小于29则添加天数
                                while (_days.count < 29) {
                                    
                                    [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
                                }
                            }
                        }else{
                            
                            if (month == 2) {
                                
                                long long int daysCount = _days.count ;
                                //若上个月份的天数大于28则移除多余的天数
                                while (_days.count > 28) {
                                    [_days removeLastObject];
                                }
                                
                                //若上个月的天数小于28则添加天数
                                while (_days.count < 28) {
                                    
                                    [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
                                }
                                
                            }
                        }
                        
                        //1 3 5 7 8 10 12 月份  31天
                        if (month == 1 ||month == 3 ||month == 5 ||month == 7 ||month == 8 ||month == 10 ||month == 12) {
                            
                            while (_days.count < 31) {
                                
                                long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                                [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
                            }
                        }
                        if (month == 4 ||month == 6 ||month == 9 ||month == 11) {
                            
                            if (_days.count == 31) {
                                [_days removeLastObject];
                            }else{
                             
                                while (_days.count < 30) {
                                    
                                    long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                                    [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
                                }
                            }
                        }
                        
                        [weakSelf.pickView reloadComponent:2];
                        
                        //根据更新完的控件更新时间戳
                        if (_lastDayIndex >= _days.count) {
                            _lastDayIndex = _days.count - 1;
                        }
                        NSString *timeStr = [NSString stringWithFormat:@"%@%@%@",_years[_lastYearIndex],_months[_lastMonthIndex],_days[_lastDayIndex]];
                        
                        //回调方法
                        _currentTimeStamp = [PTTDateKit timestampWithYearMonthDayStyle2String:timeStr];
                        action(weakSelf.pickView,compoent,row,timeStr,_currentTimeStamp);
                    } thirdTitles:_days
                     thirdAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         _lastDayIndex = row;
                         NSString *timeStr = [NSString stringWithFormat:@"%@%@%@",_years[_lastYearIndex],_months[_lastMonthIndex],_days[_lastDayIndex]];
                         
                         _currentTimeStamp = [PTTDateKit timestampWithYearMonthDayStyle2String:timeStr];
                         action(weakSelf.pickView,compoent,row,timeStr,_currentTimeStamp);
                     }
                        rowHight:rowHeight
                       fontClass:nil
                        fontSize:fontSize
                       fontColor:fontColor
                   linkageEnable:NO];
    
    if ([res isKindOfClass:[PTTPickView class]]) {
        return res;
    }
    
    return nil;
}

/**
 给定一个时间戳 选中时间戳给定的时间  时间戳需精确到毫秒
 
 @param timeStamp 以毫秒为单位的时间戳
 */
-(void)selectTimeWithTimeStamp:(long long int)timeStamp{
    
    //将时间戳转化为时间
    NSString *timeStr = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:timeStamp];
    NSArray *timeTags = [timeStr componentsSeparatedByString:@"-"];
    
    if (timeTags.count < 3)return;
    
    if (!_years || !_months || !_days || !_pickView)return;
    
    NSString *yearStr = [NSString stringWithFormat:@"%@年",timeTags[0]];
    NSString *monthStr = [NSString stringWithFormat:@"%lu月",(long)[timeTags[1] integerValue]];
    NSString *dayStr = [NSString stringWithFormat:@"%lu日",(long)[timeTags[2] integerValue]];
    
    long long int yearIndex = [_years indexOfObject:yearStr];
    long long int monthIndex = [_months indexOfObject:monthStr];
    long long int dayIndex = [_days indexOfObject:dayStr];
    
    long long int year = [timeTags[0] integerValue];
    long long int month = [timeTags[1] integerValue];
    
    //修改全局保存的日期参数
    _lastYearIndex = yearIndex;
    _lastMonthIndex = monthIndex;
    _lastDayIndex = dayIndex;
    
    //修改特殊情况时_days数组的值
    //如果是闰年 则2月有29天 否则2月有28天
    if ((year%4==0 && year%100!=0) || year%400 ==0){
        
        if (month == 2) {
            
            long long int daysCount = _days.count ;
            //若上个月份的天数大于29则移除多余的天数
            while (_days.count > 29) {
                [_days removeLastObject];
            }
            
            //若上个月的天数小于29则添加天数
            while (_days.count < 29) {
                
                [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
            }
        }
    }else{
        
        if (month == 2) {
            
            long long int daysCount = _days.count ;
            //若上个月份的天数大于28则移除多余的天数
            while (_days.count > 28) {
                [_days removeLastObject];
            }
            
            //若上个月的天数小于28则添加天数
            while (_days.count < 28) {
                
                [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
            }
            
        }
    }
    
    //1 3 5 7 8 10 12 月份  31天
    if (month == 1 ||month == 3 ||month == 5 ||month == 7 ||month == 8 ||month == 10 ||month == 12) {
        
        while (_days.count < 31) {
            
            long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
            [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
        }
    }
    if (month == 4 ||month == 6 ||month == 9 ||month == 11) {
        
        if (_days.count == 31) {
            [_days removeLastObject];
        }else{
            
            while (_days.count < 30) {
                
                long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
            }
        }
    }
    
    //刷新days数组数据
    [_pickView reloadComponent:2];
    
    [_pickView selectRow:yearIndex inComponent:0 animated:YES];
    [_pickView selectRow:monthIndex inComponent:1 animated:YES];
    [_pickView selectRow:dayIndex inComponent:2 animated:YES];
}

/**
 根据给定的年月日,选中对应的日期
 
 @param year 年
 @param month 月
 @param day 日
 */
-(void)selectTimeWithYear:(long long int)year month:(long long int)month day:(long long int)day{
    
    if (!_years || !_months || !_days || !_pickView)return;
    
    long long int yearIndex = [_years indexOfObject:[NSString stringWithFormat:@"%lu年",(long)year]];
    long long int monthIndex = [_months indexOfObject:[NSString stringWithFormat:@"%lu月",(long)month]];
    long long int dayIndex = [_days indexOfObject:[NSString stringWithFormat:@"%lu日",(long)day]];
    
    //修改全局保存的日期参数
    _lastYearIndex = yearIndex;
    _lastMonthIndex = monthIndex;
    _lastDayIndex = dayIndex;
    
    //修改特殊情况时_days数组的值
    //如果是闰年 则2月有29天 否则2月有28天
    if ((year%4==0 && year%100!=0) || year%400 ==0){
        
        if (month == 2) {
            
            long long int daysCount = _days.count ;
            //若上个月份的天数大于29则移除多余的天数
            while (_days.count > 29) {
                [_days removeLastObject];
            }
            
            //若上个月的天数小于29则添加天数
            while (_days.count < 29) {
                
                [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
            }
        }
    }else{
        
        if (month == 2) {
            
            long long int daysCount = _days.count ;
            //若上个月份的天数大于28则移除多余的天数
            while (_days.count > 28) {
                [_days removeLastObject];
            }
            
            //若上个月的天数小于28则添加天数
            while (_days.count < 28) {
                
                [_days addObject:[NSString stringWithFormat:@"%lu日",++daysCount]];
            }
            
        }
    }

    //1 3 5 7 8 10 12 月份  31天
    if (month == 1 ||month == 3 ||month == 5 ||month == 7 ||month == 8 ||month == 10 ||month == 12) {
        
        while (_days.count < 31) {
            
            long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
            [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
        }
    }
    if (month == 4 ||month == 6 ||month == 9 ||month == 11) {
        
        if (_days.count == 31) {
            [_days removeLastObject];
        }else{
            
            while (_days.count < 30) {
                
                long long int dayCount = [[[_days lastObject] substringToIndex:3] integerValue];
                [_days addObject:[NSString stringWithFormat:@"%lu日",++dayCount]];
            }
        }
    }

    //刷新days数组数据
    [_pickView reloadComponent:2];
    
    [_pickView selectRow:yearIndex inComponent:0 animated:YES];
    [_pickView selectRow:monthIndex inComponent:1 animated:YES];
    [_pickView selectRow:dayIndex inComponent:2 animated:YES];
}

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
-(instancetype)createPlacePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *timePickView,long long int compoent,long long int row,NSString *province,NSString *city,NSString *county))action{

    //初始化默认显示的数据
    _lastProvince = @"";
    _lastCity = @"";
    _lastCounty = @"";
    
    /**
     *  获取城市数据
     */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    _chinaPlaceDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (_chinaPlaceDic) {
        
        //获取省份名字
        _provinces = [NSMutableArray arrayWithArray:[_chinaPlaceDic allKeys]];
        
        //获取第一个省份的所有市
        NSArray *cityArray = [_chinaPlaceDic objectForKey:_provinces[0]];
        NSDictionary *cityDic = [cityArray firstObject];
        _citys = [NSMutableArray arrayWithArray:[cityDic allKeys]];
        
        //获取第一个市下的所有县
        _countys = [NSMutableArray arrayWithArray:[cityDic objectForKey:_citys[0]]];
    }else{
        
        _provinces = [NSMutableArray arrayWithArray:@[@"--"]];
        _citys = [NSMutableArray arrayWithArray:@[@"--"]];
        _countys = [NSMutableArray arrayWithArray:@[@"--"]];
    }
    
    WK(weakSelf);
    id res = [self initWithFrame:frame
                    firstsTitles:_provinces
                     firstAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         //更新城市数据
                         NSArray *cityArray = [_chinaPlaceDic objectForKey:_provinces[row]];
                         NSDictionary *cityDic = [cityArray firstObject];
                         NSArray *newCitys = [cityDic allKeys];
                         [_citys removeAllObjects];
                         [newCitys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                             [_citys addObject:obj];
                         }];
                         
                         if (_citys.count == 0) {
                             
                            [_citys addObject:@" "];
                         }
                         [weakSelf.pickView reloadComponent:1];
                         
                         //更新县区数据
                         [_countys removeAllObjects];
                         NSArray *arrayOfConuty =[cityDic objectForKey:_citys[0]];
                        [arrayOfConuty enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             
                             [_countys addObject:obj];
                         }];
                         if (_countys.count == 0) {
                             [_countys addObject:@" "];
                         }
                         [weakSelf.pickView reloadComponent:2];

                         _lastProvince = _provinces[row];
                         _lastCity = _citys[0];
                         _lastCounty = _countys[0];

                         action(weakSelf.pickView,compoent,row,_lastProvince,_lastCity,_lastCounty);
                     }
                   secondeTitles:_citys
                    secondAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                        
                        //更新城市数据
                        NSArray *cityArray = [_chinaPlaceDic objectForKey:_lastProvince];
                        NSDictionary *cityDic = [cityArray firstObject];
                        
                        //更新县区数据
                        [_countys removeAllObjects];
                        NSArray *arrayOfConuty =[cityDic objectForKey:_citys[row]];
                        [arrayOfConuty enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            [_countys addObject:obj];
                        }];
                        if (_countys.count == 0) {
                            [_countys addObject:@" "];
                        }
                        [weakSelf.pickView reloadComponent:2];
                        
                        _lastCity = _citys[row];
                        _lastCounty = _countys[0];
                        
                        action(weakSelf.pickView,compoent,row,_lastProvince,_lastCity,_lastCounty);
                    }
                     thirdTitles:_countys
                     thirdAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         _lastCounty = _countys[row];
                         action(weakSelf.pickView,compoent,row,_lastProvince,_lastCity,_lastCounty);
                     }
                        rowHight:rowHeight
                       fontClass:nil
                        fontSize:fontSize
                       fontColor:fontColor
                   linkageEnable:YES];
    
    if ([res isKindOfClass:[PTTPickView class]]) {
        return res;
    }
    
    return nil;
}

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
-(instancetype)createPTTPlacePickerWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor selectAction:(void (^)(UIPickerView *pickView,NSString * currentProvince,NSString* proviceNumber,NSString *currentCity,NSString *cityNumber,NSString *currentCounty,NSString *countyNumber))action{
    
    //从本地读取所有省份Dictionary
    NSString *provincesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Provice" ofType:@"plist"];
    _pttProvinceRootDic = [NSDictionary dictionaryWithContentsOfFile:provincesPath];

    //获取所有省份名数组
    _pttProvinces = [NSMutableArray array];
    for (int i = 1; i < 35; i ++) {
        
        //通过遍历,根据顺序获得省份列表
        [_pttProvinceRootDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj integerValue] == i) {
                
                [_pttProvinces addObject:key];
            }
        }];
    }
    
    //获取当前显示的省份名
    _pttCurrentProvince = _pttProvinces[0];
    
    
    
    //从本地读取所有城市信息Dic
    NSString *citiesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Cities" ofType:@"plist"];
    _pttCitiesRootDic = [NSDictionary dictionaryWithContentsOfFile:citiesPath];
    
    //获取当前选择的城市信息Dic
    _pttCurrentProvince = _pttProvinces[0];
    NSDictionary *cityInfoOfCurrentProvince = [_pttCitiesRootDic objectForKey:_pttCurrentProvince];
    _pttCurrentCityDic = cityInfoOfCurrentProvince;

    //获取当前选择省份对应的城市数组
    _pttCurrentCities = [NSMutableArray arrayWithArray:[cityInfoOfCurrentProvince allKeys]];
    
    //获取当前显示的城市名
    _pttCurrentCity = _pttCurrentCities[0];
    
    
    
    //从本地读取所有的县区信息
    NSString *countiesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Counties" ofType:@"plist"];
    _pttCountiesRootDic = [NSDictionary dictionaryWithContentsOfFile:countiesPath];
    
    //获取当前选择的区县信息Dic
    _pttCurrentCounty = _pttCurrentCities[0];
    NSDictionary *countyInfoOfCurrentProvince = [_pttCountiesRootDic objectForKey:_pttCurrentCounty];
    
    //获取当前选择区县对应的城市数组
    _pttCurrentCounties = [NSMutableArray arrayWithArray:[countyInfoOfCurrentProvince allKeys]];
    
    //获取当前显示的区县名
    _pttCurrentCounty = _pttCurrentCounties[0];
    
    WK(weakSelf);
    id res = [self initWithFrame:frame
                    firstsTitles:_pttProvinces
                     firstAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         //更新当前省份对应城市名数组
                         NSString *currentProvince = _pttProvinces[row];
                         NSDictionary *citiesDic = [_pttCitiesRootDic objectForKey:currentProvince];
                         _pttCurrentCityDic = citiesDic;
                         [_pttCurrentCities removeAllObjects];
                         for (id tmp in [citiesDic allKeys]){
                             
                             [_pttCurrentCities addObject:tmp];
                         }
                         
                         //更新当前城市名对应的区县数组
                         NSString *currentCity = _pttCurrentCities[0];
                         NSDictionary *countiesDic = [_pttCountiesRootDic objectForKey:currentCity];
                         [_pttCurrentCounties removeAllObjects];
                         for (id tmp in [countiesDic allKeys]){
                             
                             [_pttCurrentCounties addObject:tmp];
                         }
                         
                         //更新当前省份信息
                         _pttCurrentProvince = _pttProvinces[row];
                         
                         //更新当前的城市信息
                         if (_pttCurrentCities.count > 0) {
                             _pttCurrentCity = _pttCurrentCities[0];
                         }
                         
                         //更新当前的区县信息
                         if (_pttCurrentCounties.count > 0) {
                             _pttCurrentCounty = _pttCurrentCounties[0];
                         }

                         //刷新城市数据
                         [weakSelf.pickView reloadComponent:1];
                         
                         //刷新区县数据
                         [weakSelf.pickView reloadComponent:2];
                         
                         //回调方法
                         action(weakSelf.pickView,_pttCurrentProvince,[_pttProvinceRootDic objectForKey:_pttCurrentProvince],_pttCurrentCity,[citiesDic objectForKey:_pttCurrentCity],_pttCurrentCounty,[countiesDic objectForKey:_pttCurrentCounty]);
                     }
                   secondeTitles:_pttCurrentCities
                    secondAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                       
                       //获取当前城市信息Dic
                       NSDictionary *citiesDic = [_pttCitiesRootDic objectForKey:_pttCurrentProvince];
                        _pttCurrentCityDic = citiesDic;
                        
                       //更新当前显示的城市信息
                       _pttCurrentCity = _pttCurrentCities[row];
                       
                        
                        //更新当前城市名对应的区县数组
                        NSDictionary *countiesDic = [_pttCountiesRootDic objectForKey:_pttCurrentCity];
                        [_pttCurrentCounties removeAllObjects];
                        for (id tmp in [countiesDic allKeys]){
                            
                            [_pttCurrentCounties addObject:tmp];
                        }
                        //更新当前的区县信息
                        if (_pttCurrentCounties.count > 0) {
                            
                            _pttCurrentCounty = _pttCurrentCounties[0];
                        }
                        
                        //刷新区县数据
                        [weakSelf.pickView reloadComponent:2];
                        
                       //回调方法
                       action(weakSelf.pickView,_pttCurrentProvince,[_pttProvinceRootDic objectForKey:_pttCurrentProvince],_pttCurrentCity,[citiesDic objectForKey:_pttCurrentCity],_pttCurrentCounty,[countiesDic objectForKey:_pttCurrentCounty]);
                   }
                     thirdTitles:_pttCurrentCounties
                     thirdAction:^(UIPickerView *pickView, long long int compoent, long long int row) {
                         
                         //获取当前区县信息Dic
                         NSDictionary *countiesDic = [_pttCountiesRootDic objectForKey:_pttCurrentCity];
                         
                         //更新当前区县的城市信息
                         if (_pttCurrentCounties.count > 0) {
                             
                             _pttCurrentCounty = _pttCurrentCounties[row];
                         }
                         
                         //回调方法
                         action(weakSelf.pickView,_pttCurrentProvince,[_pttProvinceRootDic objectForKey:_pttCurrentProvince],_pttCurrentCity,[_pttCurrentCityDic objectForKey:_pttCurrentCity],_pttCurrentCounty,[countiesDic objectForKey:_pttCurrentCounty]);
                     }
                        rowHight:rowHeight
                       fontClass:nil
                        fontSize:fontSize
                       fontColor:fontColor
                   linkageEnable:YES];

    if ([res isKindOfClass:[PTTPickView class]]) {
        
        return res;
    }
    
    return nil;
}

static NSDictionary *_staticProvinceRootDic;
static NSDictionary *_staticpttCitiesRootDic;
static NSDictionary *_staticpttCountiesRootDic;


/**
 根据给定的省份Id 和给定的城市id 返回对应的城市名  葡萄藤专用
 
 @param provinceId 省份id
 @param cityId 城市id
 @return 两个id对应的城市名
 */
+(NSString*)pttCityOfProvinceId:(long long int)provinceId andCityId:(long long int)cityId{
    
    //从本地读取所有省份Dictionary
    NSString *provincesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Provice" ofType:@"plist"];
    _staticProvinceRootDic = [NSDictionary dictionaryWithContentsOfFile:provincesPath];

    //从本地读取所有城市信息Dic
    NSString *citiesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Cities" ofType:@"plist"];
    _staticpttCitiesRootDic = [NSDictionary dictionaryWithContentsOfFile:citiesPath];
    
    __block NSString *province = nil;
    //根据省份id取得对应省份名
    if (provinceId) {
        
        [_staticProvinceRootDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            if ([obj integerValue] == provinceId) {
                
                province = key;
            }
        }];
    }else{
        
        return nil;
    }
    
    //获取省份名对应的地点信息Info
    NSDictionary *cityInfoDic = [_staticpttCitiesRootDic objectForKey:province];
    //通过遍历取出id对应的城市名
    __block NSString *cityName = nil;
    [cityInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([obj integerValue] == cityId) {
            
            cityName = key;
        }
    }];
    return cityName;
}

/**
 根据省市县id获取对应的城市信息
 
 @param provinceId 省id
 @param cityId 城市id
 @param countyid 县id
 @param action 通过回调获取城市信息
 */
+(void)pttGetInfoWithProvinceId:(long long int)provinceId andCityId:(long long int)cityId andCountyId:(long long int)countyId withAction:(void (^)(NSString *provinceName, NSString *cityName,NSString *countyName))action{
    
    //从本地读取所有省份Dictionary
    NSString *provincesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Provice" ofType:@"plist"];
    _staticProvinceRootDic = [NSDictionary dictionaryWithContentsOfFile:provincesPath];
    
    //从本地读取所有城市信息Dic
    NSString *citiesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Cities" ofType:@"plist"];
    _staticpttCitiesRootDic = [NSDictionary dictionaryWithContentsOfFile:citiesPath];
    
    //从本地读取所有县区Dic
    NSString *countysPath = [[NSBundle mainBundle] pathForResource:@"PTT_Counties" ofType:@"plist"];
    _staticpttCountiesRootDic = [NSDictionary dictionaryWithContentsOfFile:countysPath];
    
    __block NSString *province = nil;
    //根据省份id取得对应省份名
    if (provinceId) {
        
        [_staticProvinceRootDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj integerValue] == provinceId) {
                
                province = key;
            }
        }];
    }else{
    }
    
    //获取省份名对应的地点信息Info
    NSDictionary *cityInfoDic = [_staticpttCitiesRootDic objectForKey:province];
    //通过遍历取出id对应的城市名
    __block NSString *cityName = nil;
    [cityInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj integerValue] == cityId) {
            
            cityName = key;
        }
    }];
    
    //获取县区名
    NSDictionary *countyInfoDic = [_staticpttCountiesRootDic objectForKey:cityName];
    //通过遍历取出id对应的城市名
    __block NSString *countyName = nil;
    [countyInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj integerValue] == countyId) {
            
            countyName = key;
        }
    }];
    
    if (action) {
        
        action(province,cityName,countyName);
    }
}


/**
 根据给定的省份id和给定的城市id,将选择器选中对应的城市
 处理数据耗时略长,操作将会主副线程间切换

 @param provinceId 省份id
 @param cityId 城市id
 */
-(void)selectPlaceWithProvinceId:(long long int)provinceId andCityId:(long long int)cityId{
    
    
    if (!_pickView || !_pttProvinces || provinceId < 0 || cityId < 0) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    //从本地读取所有省份Dictionary
    NSString *provincesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Provice" ofType:@"plist"];
    _staticProvinceRootDic = [NSDictionary dictionaryWithContentsOfFile:provincesPath];
    
    //从本地读取所有城市信息Dic
    NSString *citiesPath = [[NSBundle mainBundle] pathForResource:@"PTT_Cities" ofType:@"plist"];
    _staticpttCitiesRootDic = [NSDictionary dictionaryWithContentsOfFile:citiesPath];
    
    __block NSString *province = nil;
    //根据省份id取得对应省份名
    if (provinceId) {
        
        [_staticProvinceRootDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj integerValue] == provinceId) {
                
                province = key;
            }
        }];
    }
    
    //如果获取不到省份名,则退出方法
    if (!province) {
            return ;
    }
        
    //获取省份名对应的地点信息Info
    NSDictionary *cityInfoDic = [_staticpttCitiesRootDic objectForKey:province];
    //通过遍历取出id对应的城市名
    __block NSString *cityName = nil;
    [cityInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj integerValue] == cityId) {
            
            cityName = key;
        }
    }];
    
    //获取到
    NSArray *cities = [cityInfoDic allKeys];
    //刷新城市列表
    [_pttCurrentCities removeAllObjects];
    for (id tmp in cities){
            
        [_pttCurrentCities addObject:tmp];
    }
        
    //获取省份名和城市名对应的下标
    long long int provinceIndex = [_pttProvinces indexOfObject:province];
    long long int cityIndex = [_pttCurrentCities indexOfObject:cityName];
    
       dispatch_async(dispatch_get_main_queue(), ^{
       
           [_pickView reloadComponent:1];
           [_pickView selectRow:provinceIndex inComponent:0 animated:YES];
           [_pickView selectRow:cityIndex inComponent:1 animated:YES];
        });
    });
}

#pragma mark 私有接口
-(long long int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return _numberOfComponent;
}

-(long long int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(long long int)component{
    long long int numberOfRows = 0;
    switch (component) {
        case 0:
            if (_firstTitles) {
                numberOfRows = _firstTitles.count;
            }
            break;
        case 1:
            if (_secondTitles) {
                numberOfRows = _secondTitles.count;
            }
            break;
        case 2:
            if (_thirdTitles) {
                numberOfRows = _thirdTitles.count;
            }
            break;
    }
    
    return numberOfRows;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(long long int)row forComponent:(long long int)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/_numberOfComponent, _rowHeight)];
    label.backgroundColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    
    if (_fontClass) {
        
        label.font = [[[(UIFont*)_fontClass class] alloc] fontWithSize:_fontSize];
    }else{
        
        label.font = [UIFont systemFontOfSize:_fontSize];
    }
    label.textColor = _fontColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    NSString *title = nil;
    switch (component) {
        case 0:
            if (_firstTitles && _firstTitles.count > row) {
                title = _firstTitles[row];
            }
            break;
        case 1:
            if (_secondTitles && _secondTitles.count > row) {
                title = _secondTitles[row];
            }
            break;
        case 2:
            if (_thirdTitles && _thirdTitles.count > row) {
                title = _thirdTitles[row];
            }
            break;
        default: title = @"暂无数据";
    }
    
    label.text = title;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(long long int)row inComponent:(long long int)component{
    
    WK(weakSelf);
    
    if(component == 0 && _firstAction){
        
        _firstAction(weakSelf.pickView,component,row);
    }
    if(component == 1 && _senondAction){
        
        _senondAction(weakSelf.pickView,component,row);
    }
    if(component == 2 && _thirdAction){
        
        _thirdAction(weakSelf.pickView,component,row);
    }
    
    //如果需要联动的话  更新后面列数据
    if(_linkEnable){
        
        while (component + 1 < _numberOfComponent) {
            
            component ++;
            [pickerView selectRow:0 inComponent:component animated:YES];
        }
    }
}

@end
