//
//  NSString+PTT.m
//  dounixue-iOS
//
//  Created by 赵广亮 on 2018/4/3.
//  Copyright © 2018年 zhaoguangliang. All rights reserved.
//

#import "NSString+PTT.h"

@implementation NSString_PTT

-(NSString *)regularPattern:(NSArray *)keys{
    
    NSMutableString *pattern = [[NSMutableString alloc]initWithString:@"(?i)"];
    for (NSString *key in keys) {
        
        [pattern appendFormat:@"%@|",key];
    }
    return pattern;
}

- (void)setAttributedText:(NSString *)text withRegularExpression:(NSRegularExpression *)expression attributes:(NSDictionary *)attributesDict{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [expression enumerateMatchesInString:text
                                 options:0
                                   range:NSMakeRange(0, [text length])
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                          
                                  NSRange matchRange = [result range];
                                  if (attributesDict) {
                                      
                                      [attributedString addAttributes:attributesDict range:matchRange];
                                  }
                                  
                                  if ([result resultType] == NSTextCheckingTypeLink) {
                                      
                                      NSURL *url = [result URL];
                                      [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                                  }
                              }];
    
    
}



@end
