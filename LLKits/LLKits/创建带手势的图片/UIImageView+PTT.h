//
//  UIImageView+PTTCate.h
//  PTTFramework
//
//  Created by 赵广亮 on 2016/10/15.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 需导入UIImageView+PTT框架
 说明:
 1.创建一个UIImageView+PTT对象  为该对象添加事件处理Block,可以快速集成点击图片之后,该Block获得执行机会
 
 2.提供占位图,若传入图片读取不出数据,则加载默认占位图
 
 3.依赖于SDImage加载网络图片  项目中需导入UIImageView+PTT 框架,在
 
 4.考虑到最长用的图片展示模式和为默认图片大小和拉伸图片充满,所以提供两个枚举方便选择
 */

@interface UIImageView (PTTCate)<NSCopying>

typedef enum{
    PTT_ImageView_Image_Contend_Mode_Aspect = UIViewContentModeCenter,  //保持图片大小
    PTT_ImageView_Image_Contend_Mode_Fill = UIViewContentModeScaleToFill,    //拉伸图片铺满当前视图
    
}PTT_ImageView_Image_Contend_Mode;

/**
 *  从本地读取图片创建UIImageView+PTTCate对象
 *
 *  @param frame       imageView尺寸
 *  @param imageName   图片名
 *  @param contendMode 填充模式  (图片本身大小/拉伸图片适应UIImageView)
 *  @param block       事件处理Block
 *
 *  @return UIImageView+PTTCate对象
 */
-(instancetype)initWithframe:(CGRect)frame andImage:(NSString *)imageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode withAction:(void (^)(id sender))block;

/**
 *  从网络读取图片创建UIImageView+PTTCate对象
 *
 *  @param frame          imageView尺寸
 *  @param imageUrl       图片网络链接
 *  @param placeImageName 占位图名字(本地)
 *  @param contendMode    填充模式 (图片本身大小/拉伸图片适应UIImageView)
 *  @param block          事件处理Block
 *
 *  @return UIImageView+PTTCate对象
 */
-(instancetype)initWithframe:(CGRect)frame andImageUrl:(NSString *)imageUrl palaceolderImage:(NSString*)placeImageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode withAction:(void (^)(id sender))block;

/**
 *  使用本地图片和标题创建一个上面图片下面标题的UIImageView对象
 *
 *  @param frame     尺寸(图片+标题的尺寸)
 *  @param imageName 本地图片名
 *  @param contendMode 填充模式
 *  @param title     标题
 *  @parm  color     标题颜色
 *  @param block     回调
 *  @param fontSize  字体大小
 *
 *  @return ImageView对象
 */
-(instancetype)initWithFrame:(CGRect)frame localImage:(NSString*)imageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode title:(NSString*)title fontSize:(NSInteger)fontSize titleColor:(UIColor*)titleColor withAction:(void (^)(id sender))block;

/**
 *  使用本地图片和标题创建一个上面图片下面标题的UIImageView对象
 *
 *  @param frame     尺寸(图片+标题的尺寸)
 *  @param imageName 本地图片名
 *  @param imageFrame 图片尺寸
 *  @param contendMode 填充模式
 *  @param title     标题
 *  @parm  color     标题颜色
 *  @param block     回调
 *  @param fontSize  字体大小
 *
 *  @return ImageView对象
 */
-(instancetype)initWithFrame:(CGRect)frame localImage:(NSString*)imageName imageFrame:(CGRect)imageFrame contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode title:(NSString*)title fontSize:(NSInteger)fontSize titleColor:(UIColor*)titleColor distantWithImageAndTitle:(CGFloat)distant withAction:(void (^)(id sender))block;

/**
 *  为创建好的UIImageView添加事件处理Block 将会更新原Block
 *
 *  @param instancetype 事件处理Block
 *
 */
-(void)addAction:(void (^)(id sender))block;

/**
 *  设置图片位置,以左上角为准
 *
 *  @param origin 左上角位置
 */
-(void)setOrigin:(CGPoint)origin;

/**
 *  为图片添加描述
 *
 *  @param describe 描述文本
 */
-(void)addDescribe:(NSString*)describe;

@end
