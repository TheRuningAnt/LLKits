//
//  PTTPageControl.m
//  dounixue-iOS
//
//  Created by 赵广亮 on 2018/10/17.
//  Copyright © 2018年 zhaoguangliang. All rights reserved.
//

#import "PTTPageControl.h"

@implementation PTTPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    for (int i = 0; i < self.subviews.count; i ++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            dot.height = 2;
            dot.width = 13;
            dot.layer.cornerRadius = 0;
            //            dot.y = floorf((self.bounds.size.height - 4)/2.0);
        }else{
            
            dot.height = 2;
            dot.width = 13;
            dot.layer.cornerRadius = 0;
            //            dot.y = floorf((self.bounds.size.height - 1.5)/2.0);
        }
    }
}

-(void)updateDots{
    
    for (int i = 0; i < self.subviews.count; i ++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            dot.height = 2;
            dot.width = 13;
            dot.layer.cornerRadius = 0;
//            dot.y = floorf((self.bounds.size.height - 4)/2.0);
        }else{
            
            dot.height = 2;
            dot.width = 13;
            dot.layer.cornerRadius = 0;
//            dot.y = floorf((self.bounds.size.height - 1.5)/2.0);
        }
    }
}

@end
