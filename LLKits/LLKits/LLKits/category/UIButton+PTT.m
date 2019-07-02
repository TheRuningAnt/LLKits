//
//  UIButton+PTT.m
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2017/10/18.
//  Copyright © 2017年 董彩丽. All rights reserved.
//

#import "UIButton+PTT.h"

@implementation UIButton (PTT)

-(void)pttSetAllStateBackgroundImgStr:(NSString *)imgStr{
    
    if (imgStr) {
        
        [self setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];
    }
}

-(void)pttSetAllStateImgStr:(NSString*)imgStr{
    
    if (imgStr) {
        
        [self setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imgStr] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];
    }
}

@end
