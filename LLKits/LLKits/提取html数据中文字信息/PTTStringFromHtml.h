//
//  PTTStringFromHtml.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTStringFromHtml : NSObject

/**
 根据传入的html代码 获取其中的文本内容

 @param html html代码
 */
+(NSString*)stringFromHtml:(NSString*)html;

@end
