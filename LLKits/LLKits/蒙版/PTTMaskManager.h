//
//  PTTMaskManager.h
//  TestWindow_0221
//
//  Created by 赵广亮 on 2017/2/21.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTTMaskManagerDelegaete <NSObject>

-(void)touchRemove;

@end

@interface PTTMaskManager : UIWindow

/**
 在从UIWindow层面添加蒙版

 @param subView 在蒙版上添加的view
 @param maskDelegaete 设置移除代理
 */
+(void)pttAddMaskWithView:(UIView*)subView delegaete:(id <PTTMaskManagerDelegaete>)maskDelegaete;


/**
 将蒙版从当前的应用中移除
 */
+(void)pttRemoveMask;

/**
 在从UIWindow层面添加蒙版--背景空白
 
 @param subView 在蒙版上添加的view
 @param maskDelegaete 设置移除代理
 */
+(void)pttClearBackAddMaskWithView:(UIView*)subView delegaete:(id <PTTMaskManagerDelegaete>)maskDelegaete;
;
/**
 获取当前的遮罩

 @return 返回当前的遮罩
 */
+(PTTMaskManager*)currentMaskManager;
@end
