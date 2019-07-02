//
//  PttBaseViewController.h
//  PTTNavtionController
//
//  Created by 赵广亮 on 2016/11/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  创建公共父类 PTTBaseViewController
 
 若要隐藏整个导航栏,调用pttHideNavtionBar方法
 若仅仅需要设置导航栏背景透明,可调用pttSNavBackgroundColor将颜色设置为透明
 若设置使用次数比较多的导航栏背景颜色,请修改源码: 
 _bacImgeV.backgroundColor = [UIColor cyanColor];
 
 如需设定导航栏右侧按钮
 1.完全自定义按钮的属性(frame,title,image),之后调用方法
 -(void)pttSetRightbtn:(UIButton*)button action:(void(^)())action;

 2.传入图片名,调用方法
 -(void)pttSetRightBtnStr:(NSString*)imgStr action:(void(^)())action;

 
 默认背景不透明
 
 默认效果:
 默认不隐藏导航栏
 默认导航栏不透明
 默认导航背景颜色默认为天蓝色 cyanColor
 默认返回按钮图片为 Utils-Kit-back,可自行在该控制器中修改
 默认不设置右侧按钮及点击事件,可自行添加
 */
@interface PTTBaseViewController : UIViewController

#pragma mark =================导航栏背景属性=================
/**
 设置导航栏背景图片
 
 @param backgroundImageStr 导航栏背景图片名
 */
-(void)pttSetNavtionBackImageWithImageStr:(NSString*)backgroundImageStr;

/**
 设置导航栏背景颜色
 @param navBackgroundColor 导航栏背景颜色
 */
-(void)pttSetNavBackgroundColor:(UIColor*)navBackgroundColor;

/**
 设置导航栏透明度

 @param alpha 透明度
 */
-(void)pttSetNavtionBarAlpha:(CGFloat)alpha;

/**
   隐藏整个导航栏
 */
-(void)pttHideNavtionBar;


/**
 显示整个导航栏
 */
-(void)pttShowNavtionBar;

/**
 隐藏分割线
 */
-(void)pttHideNavtionLine;



#pragma mark =================导航栏按钮属性=================
/**
 设置左侧按钮的图片和点击事件
 
 @param imgStr 左侧按钮图片名
 @param action 左侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetLeftBtnStr:(NSString*)imgStr action:(void(^)())action;

/**
 设置导航栏自定义左侧按钮,可自定义左侧按钮格式

 @param button 左侧按钮
 @param action 左侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetLeftbtn:(UIButton*)button action:(void(^)())action;

/**
  隐藏左侧返回按钮
 */
-(void)pttHideLeftBtn;

/**
 设置左侧按钮隐藏属性

 @param hide 是否隐藏
 */
-(void)pttSetLeftBtnHide:(BOOL)hide;

/**
  设置右侧按钮的图片和点击事件

 @param imgStr 右侧按钮图片名
 @param action 右侧按钮点击事件
 */
-(void)pttSetRightBtnStr:(NSString*)imgStr action:(void(^)())action;

/**
 设置导航栏自定义右侧按钮,可自定义左侧按钮格式
 
 @param button 右侧按钮
 @param action 右侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetRightbtn:(UIButton*)button action:(void(^)())action;

/**
  设置右侧按钮显示属性  如果有的话
*/
-(void)pttSetRightHide:(BOOL)hide;

#pragma mark =================导航栏标题属性=================
/**
 设置导航栏标题详细属性

 @param title 导航栏标题
 @param fontSize 字体大小
 @param fontColor 字体颜色
 @param font  特殊字体,不设定使用系统默认字体
 */
-(void)pttSetNavTitle:(NSString*)title fontSize:(CGFloat)fontSize color:(UIColor*)fontColor font:(UIFont*)font;

/**
 设置标题
 */
-(void)pttSetTitle:(NSString*)title;

/**
 设置标题颜色

 @param titleColor 标题颜色
 */
-(void)pttSetTitleColor:(UIColor*)titleColor;


/**
 设置标题位置

 @param textAlignment 标题位置
 @param value 距离左右两边的值
 */
-(void)pttsetTitleAlgiment:(NSTextAlignment)textAlignment value:(CGFloat)value;

#pragma mark =================方法=================

/**
 添加子视图

 @param superView 父类视图
 @param subView 子类视图
 */
-(void)pttView:(UIView*)superView AddSubView:(UIView*)subView;

/**
 推出下个控制器

 @param viewController 子controller
 @param animated 是否有动画
 */
- (void)pttPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 更改当前controller下方的tabBarItem选中和未选中图片
 
 @param normalImgName 未选中图片
 @param selectImgName 选中图片
 */
-(void)pttChangeTabBarNormalImageName:(NSString*)normalImgName selectImageName:(NSString*)selectImgName;

/**
 设置适配IphoneX顶部图片颜色

 @param color 颜色
 */
-(void)pttChangeTopTmpViewBackground:(UIColor*)color;


@end
