//
//  NSString+PTT.h
//  dounixue-iOS
//
//  Created by 赵广亮 on 2018/4/3.
//  Copyright © 2018年 zhaoguangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString_PTT : NSString

-(NSString *)regularPattern:(NSArray *)keys;

- (void)setAttributedText:(NSString *)text withRegularExpression:(NSRegularExpression *)expression attributes:(NSDictionary *)attributesDict;
@end
