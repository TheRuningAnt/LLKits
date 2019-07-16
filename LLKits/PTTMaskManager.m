//
//  PTTMaskManager.m
//  TestWindow_0221
//
//  Created by 赵广亮 on 2017/2/21.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import "PTTMaskManager.h"

@implementation PTTMaskManager

static PTTMaskManager *maskManager = nil;
+(instancetype)getMaskSignleton{
    
    if (!maskManager) {
        
        UIImageView *backImageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backImageV.image = [UIImage imageNamed:@"back-opaque"];
        backImageV.tag = 1001;
        
        maskManager = [[PTTMaskManager alloc] init];
        maskManager.backgroundColor = [UIColor clearColor];
        maskManager.rootViewController = [[UIViewController alloc] init];
        maskManager.rootViewController.view.backgroundColor = [UIColor clearColor];
        [maskManager.rootViewController.view addSubview:backImageV];
        maskManager.windowLevel = UIWindowLevelAlert;
        maskManager.hidden = NO;
    }
    return maskManager;
}

/**
 在从UIWindow层面添加蒙版
 
 @param subView 在蒙版上添加的view
 @param maskDelegaete 设置移除代理
 */
+(void)pttAddMaskWithView:(UIView*)subView delegaete:(id <PTTMaskManagerDelegaete>)maskDelegaete;
{
    
    maskManager = [PTTMaskManager getMaskSignleton];
    deldgate =maskDelegaete;
    if (subView) {
        
        [maskManager.rootViewController.view addSubview:subView];
    }
}

/**
 在从UIWindow层面添加蒙版--背景空白
 
 @param subView 在蒙版上添加的view
 @param maskDelegaete 设置移除代理
 */
+(void)pttClearBackAddMaskWithView:(UIView*)subView delegaete:(id <PTTMaskManagerDelegaete>)maskDelegaete;
{
    
    maskManager = [PTTMaskManager getMaskSignleton];
    UIImageView *imageV = [maskManager.rootViewController.view viewWithTag:1001];
    if (imageV) {
        imageV.image = nil;
    }
    deldgate =maskDelegaete;
    if (subView) {
        
        [maskManager.rootViewController.view addSubview:subView];
    }
}


static id deldgate;

/**
 将蒙版从当前的应用中移除
 */
+(void)pttRemoveMask{
    
    if (maskManager) {
        
        maskManager = nil;
        deldgate = nil;
    }
}

/**
 获取当前的遮罩
 
 @return 返回当前的遮罩
 */
+(PTTMaskManager*)currentMaskManager{
    
    return maskManager;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (deldgate && [deldgate respondsToSelector:@selector(touchRemove)]) {
        
        [deldgate touchRemove];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
