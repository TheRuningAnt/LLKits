//
//  PTTGuideView.h
//  goldNews-iOS
//
//  Created by 赵广亮 on 2016/12/16.
//  Copyright © 2016年 zhaoguangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTGuideView : UIView

/**
 添加引导图到视图上方

 @param imageNames 图片数组
 @return 引导图
 */
-(instancetype)initWithGuiderWithImageNames:(NSArray*)imageNames;

@end
