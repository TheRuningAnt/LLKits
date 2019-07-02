//
//  UIButton+PTT.h
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2017/10/18.
//  Copyright © 2017年 董彩丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PTT)

//设置所有状态下的背景图片
-(void)pttSetAllStateBackgroundImgStr:(NSString*)imgStr;

//设置所有状态下的前景图片
-(void)pttSetAllStateImgStr:(NSString*)imgStr;

@end
