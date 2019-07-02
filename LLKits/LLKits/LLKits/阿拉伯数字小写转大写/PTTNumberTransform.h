//
//  PTTNumberTransform.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTNumberTransform : NSObject


/**
 根据数字获取大小汉字

 @param number 传入数字,个位数
 @return 返回大写汉字 一二三四
 */
+(NSString*)pttGetWordFromNumber:(NSInteger)number;

@end
