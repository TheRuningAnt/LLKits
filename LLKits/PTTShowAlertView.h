//
//  PTTShowAlertView.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/29.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTShowAlertView : NSObject

/**创建alertView
 *  根据给定的描述文本和按钮标题以及对应的Block块创建一个alertView 
 *  自己管理自己的生命周期
 *
 *  @param title       描述文本
 *  @param cancelTitle 取消按钮标题
 *  @param cancelBlock 取消按钮调用Block块
 *  @param sureTitle   确定按钮标题
 *  @param sureBlock   确定按钮调用block块
 */
+(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancleBtnTitle:(NSString*)cancelTitle cancelAction:(void (^)())cancelBlock sureBtnTitle:(NSString*)sureTitle sureAction:(void (^)())sureBlock pttMaskDelegate:(id)delegate;


/**
 弹出系统的提示框

 *  @param title       描述文本
 *  @param cancelTitle 取消按钮标题
 *  @param cancelBlock 取消按钮调用Block块
 *  @param sureTitle   确定按钮标题
 *  @param sureBlock   确定按钮调用block块
 */
+(void)showSystemAlsertViewWithTitle:(NSString*)title message:(NSString*)message cancleBtnTitle:(NSString*)cancelTitle cancelAction:(void (^)())cancelBlock sureBtnTitle:(NSString*)sureTitle sureAction:(void (^)())sureBlock viewController:(UIViewController*)viewController;


@end
