//
//  UILabel+MessageTip.m
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2016/10/11.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "ShowMessageTipUtil.h"

@implementation ShowMessageTipUtil

/**
 根据给定的属性设置弹出框
 
 @param message 消息内容
 */
+(void)showTipLabelWithMessage:(NSString*)message{
    
    
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = message;  //结合屏幕尺寸 字体长度来考虑
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor blackColor];
        tipLabel.layer.masksToBounds = YES;
        tipLabel.layer.cornerRadius = 10;
        tipLabel.layer.opacity = 0.0;
        tipLabel.adjustsFontSizeToFitWidth = YES;
    
        CGSize expectSize = [tipLabel sizeThatFits:tipLabel.frame.size];
        if(expectSize.width < 3/4.0*kWindowWidth){
            tipLabel.frame = CGRectMake((kWindowWidth - expectSize.width)/2, 160*WIDTH_SCALE, expectSize.width + 20, 40*HEIGHT_SCALE);
        }else{
            tipLabel.frame = CGRectMake((kWindowWidth - 4/5.0*kWindowWidth)/2, 160*WIDTH_SCALE, 4/5.0*kWindowWidth, 60*HEIGHT_SCALE);
            tipLabel.numberOfLines = 2;
        }
    
        CGPoint exceptCenter = CGPointMake(kWindowWidth/2, tipLabel.frame.origin.y) ;
        tipLabel.center = exceptCenter;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            //渐变动画
            [UIView animateWithDuration:1 animations:^{
                
                [[[UIApplication sharedApplication] keyWindow] addSubview:tipLabel];
                tipLabel.layer.opacity = 0.6;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:1 animations:^{
                    
                    tipLabel.layer.opacity = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [tipLabel removeFromSuperview];
                }];
            }];
        });
}


/**
 根据给定的属性设置弹出框

 @param message 消息内容
 @param topSpace 距离屏幕顶部的距离
 @param 在页面停留时间
 */
+(void)showTipLabelWithMessage:(NSString*)message spacingWithTop:(CGFloat)topSpace stayTime:(CGFloat)stayTime{
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = message;  //结合屏幕尺寸 字体长度来考虑
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.layer.masksToBounds = YES;
    tipLabel.layer.cornerRadius = 10;
    tipLabel.layer.opacity = 0.0;
    tipLabel.adjustsFontSizeToFitWidth = YES;
    
    CGSize expectSize = [tipLabel sizeThatFits:tipLabel.frame.size];
    if(expectSize.width < 3/4.0*kWindowWidth){
        
        tipLabel.frame = CGRectMake((kWindowWidth - expectSize.width)/2, topSpace, expectSize.width + 20, 40*HEIGHT_SCALE);
    }else{
        
        tipLabel.frame = CGRectMake((kWindowWidth - 4/5.0*kWindowWidth)/2, topSpace, 4/5.0*kWindowWidth, 60*HEIGHT_SCALE);
        tipLabel.numberOfLines = 0;
    }
    
    CGPoint exceptCenter = CGPointMake(kWindowWidth/2, tipLabel.frame.origin.y) ;
    tipLabel.center = exceptCenter;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipLabel];

        //渐变动画
        [UIView animateWithDuration:stayTime/2 animations:^{
            
            tipLabel.layer.opacity = 0.6;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:stayTime/2 animations:^{
                
                tipLabel.layer.opacity = 0.0;
                
            } completion:^(BOOL finished) {
                
                [tipLabel removeFromSuperview];
            }];
        }];
    });

}

@end
