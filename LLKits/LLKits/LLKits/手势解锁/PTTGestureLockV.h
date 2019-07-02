//
//  PTTGestureLock.h
//  TestGesture_1126
//
//  Created by 赵广亮 on 2016/11/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTGestureLockV : UIView

/**
 创建手势解锁页面

 @param frame  frame
 @param action 回调Blck
     param secrets 当前选择图案对应数组, NSArray(NSNumber)
 @return PTTGestureLock
 */
-(instancetype)initWithFrame:(CGRect)frame Block:(void (^)(NSArray* secrets))action;

@end
