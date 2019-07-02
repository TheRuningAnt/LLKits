//
//  PTTCycleSrollView.h
//  TestScrollView
//
//  Created by 赵广亮 on 2016/10/15.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTTCyclevViewDelegate <NSObject>

-(void)cilickAtIndex:(NSInteger)index;

@end

/**
 说明:
 1. 该项目需导入SDImage框架
 2. 该项目需导入UIImageView+PTT框架
 3. 根据下面的两个工厂构造方法,可根据本地数据或者网络数据快速创建一个无限轮播图
 4. 将某一控制器对象设置为该轮播图的代理,并实现代理方法,当点击轮播图中某一张图片时,即可触发代理对象的代理方法,在该方法里可获得当前点击图片的下标
 5. 返回值类型为UIView
 *
 */

@interface PTTCycleSrollView : UIView

typedef NS_ENUM(NSInteger,PTT_PAGE_CONTROL_ALIGNMENT){
    PTT_PAGE_CONTROL_ALIGNMENT_LEFT = 1,    //指示器靠左摆放
    PTT_PAGE_CONTROL_ALIGNMENT_LEFT_MID,    //指示器放置中间
    PTT_PAGE_CONTROL_ALIGNMENT_RIHGT        //指示器放在右边
};

@property (nonatomic,weak)id <PTTCyclevViewDelegate> pttDelegate;

/**
 *  使用本地图片数组创建轮播图
 *
 *  @param imageNames           图片名组成的数组
 *  @param frame                创建的scrollView的大小
 *  @param autoRun              是否自动滚动
 *  @param timeInterval         滚动频率 秒/帧
 *  @param showPageControl      是否显示分页指示器
 *  @param pageControlAlignment 分页指示器的位置
 *
 *  @return PTTCycleSrollView
 */
-(instancetype)initCycleScrollViewWithLocalImages:(NSArray*)imageNames frame:(CGRect)frame autoRun:(BOOL)autoRun timeInterval:(CGFloat)timeInterval showPageControl:(BOOL)showPageControl pageControlAlignment:(PTT_PAGE_CONTROL_ALIGNMENT)pageControlAlignment;

/**
 *  使用网络数据创建轮播图
 *
 *  @param urls                 图片链接组成的数组
 *  @param placeHolderName      占位图名字(本地数据)
 *  @param frame                创建的scrollView大小
 *  @param autoRun              是否自动滚动
 *  @param timeInterval         滚动频率 秒/帧
 *  @param showPageControl      是否显示分页指示器
 *  @param pageControlAlignment 分页指示器的位置
 *
 *  @return PTTCycleSrollView
 */
-(instancetype)initCycleScrollViewWithUrlImages:(NSArray*)urls placeHolderName:(NSString*)placeHolderName frame:(CGRect)frame autoRun:(BOOL)autoRun timeInterval:(CGFloat)timeInterval showPageControl:(BOOL)showPageControl pageControlAlignment:(PTT_PAGE_CONTROL_ALIGNMENT)pageControlAlignment;

/**
 *  设置分页指示器的属性
 *
 *  @param selectColor   指示当前页面圆点的颜色
 *  @param unselectColor 待显示圆点的颜色
 */
-(void)pttSetPageControlSelectColor:(UIColor*)selectColor unselectColor:(UIColor*)unselectColor;

/**
 *  使用给定的网络图片数组和描述数组来更新scrollView
 *
 *  @param urls         图片链接数组 (NSString)
 *  @param descriptions 描述数组    (NSString)
 */
-(void)updataWithImageUrls:(NSArray*)urls andDescriptions:(NSArray*)descriptions;

@end


