//
//  PttLoadingTip.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PttLoadingTip.h"
#import <UIKit/UIKit.h>

@implementation PttLoadingTip

static UIActivityIndicatorView *indectView = nil;
static UIImageView *animationV = nil;

/**
 开始加载动画
 */
+(void)startLoading{
    
//    if (!indectView) {
//        indectView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kWindowWidth/2, kWindowHeight/2, 100, 100)];
//        indectView.center =  [UIApplication sharedApplication].keyWindow.center;
//        indectView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        indectView.color = [UIColor grayColor];
//    }
//
//    if (!indectView.superview) {
//
//        [[UIApplication sharedApplication].keyWindow addSubview:indectView];
//    }
//    if (!indectView.animating) {
//        [indectView startAnimating];
//    }
    
    [PttLoadingTip loadWaitingAnimationView];
}

/**
 停止并移除动画
 */
+(void)stopLoading{
    
//    if (indectView && indectView.animating) {
//
//        [indectView stopAnimating];
//    }
//
//    if (indectView && indectView.superview) {
//        [indectView removeFromSuperview];
//    }
    
    [PttLoadingTip removeWaitingAnimationView];
}

/**
 *  设置圆圈的中心
 *
 */
+(void)setCenter:(CGPoint)center{
    
    if (!indectView) {
        indectView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kWindowWidth/2, kWindowHeight/2, 100, 100)];
        indectView.center =  [UIApplication sharedApplication].keyWindow.center;
        indectView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indectView.color = [UIColor grayColor];
    }
    
    indectView.frame = CGRectMake(center.x, center.y, 100, 100);
}

/**
 添加动画加载动画
 */
+(void)loadWaitingAnimationView{
    
    if (!animationV) {
        
        CGFloat animationWidth = 150;
        animationV = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2 - animationWidth/2, kWindowHeight/2 - animationWidth/2, animationWidth, animationWidth)];
        NSMutableArray *images = @[].mutableCopy;
        NSBundle *bundle = [NSBundle mainBundle];
        
        for (int i = 0; i < 51; i ++) {
            
            UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"PTT_Loading_%d",i] ofType:@"png"] ];
            [images addObject:image];
        }
        
        animationV.animationImages = images;
        animationV.contentMode = UIViewContentModeScaleAspectFill;
        animationV.animationDuration = 2;
        animationV.animationRepeatCount = 0;
    }
    [PTTMaskManager pttClearBackAddMaskWithView:animationV delegaete:nil];
    [animationV startAnimating];
}

/**
 移除自定义加载动画
 */
+(void)removeWaitingAnimationView{
    
    if (animationV) {
        [animationV removeFromSuperview];
        [animationV stopAnimating];
    }
    [PTTMaskManager pttRemoveMask];

}

@end
