//
//  PTTNonNetwork.h
//  goldNews-iOS
//
//  Created by 赵广亮 on 2017/1/7.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTNonNetwork : UIView

/**
 创建无网络时的提示页面,点击刷新按钮重新发起网络请求

 @param frame frame
 @param backgroundColor 背景颜色
 @param action 点击刷新按钮回调事件
 @return 无网络加载页面
 */
-(instancetype)initWithFrame:(CGRect)frame backGroundColor:(UIColor*)backgroundColor action:(void (^)())action;

@end
