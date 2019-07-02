
//
//  PTTShowAlertView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/29.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTShowAlertView.h"
#import <objc/runtime.h>
#import "PTTMaskManager.h"

#define KAlertViewWidth 260*WIDTH_SCALE

//屏幕比例
#define WIDTH_SCALE [[UIScreen mainScreen] bounds].size.width/375.f
#define HEIGHT_SCALE [[UIScreen mainScreen] bounds].size.height/667.f

//屏幕宽高
#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight ([[UIScreen mainScreen] bounds].size.height)


@interface PTTShowAlertView()<UIAlertViewDelegate>

@end

@implementation PTTShowAlertView

static const int bind_Key;

static void (^_cancelAction)();
static void (^_sureAction)();

/**创建alertView
 *  根据给定的描述文本和按钮标题以及对应的Block块创建一个alertView
 *  自己管理自己的生命周期
 *
 *  @param title       描述文本
 *  @param cancelTitle 取消按钮标题
 *  @param cancelBlock 取消按钮调用Block块
 *  @param sureTitle   确定按钮标题
 *  @param sureBlock   确定按钮调用block块
 */
+(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancleBtnTitle:(NSString*)cancelTitle cancelAction:(void (^)())cancelBlock sureBtnTitle:(NSString*)sureTitle sureAction:(void (^)())sureBlock pttMaskDelegate:(id)delegate{
    
    _cancelAction = cancelBlock;
    _sureAction = sureBlock;
    
    //计算控件高度
    CGFloat viewHeight = 15;
    
    //创建根View
    UIView *rootV = [[UIView alloc] initWithFrame:CGRectZero];
    rootV.backgroundColor = [UIColor whiteColor];
    rootV.layer.masksToBounds = YES;
    rootV.layer.cornerRadius = 15;
    rootV.clipsToBounds = YES;
    
    //如果有标题的话添加标题Label
    if (title) {
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, KAlertViewWidth, 15)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont boldSystemFontOfSize:17];
        titleL.text = title;
        [rootV addSubview:titleL];
        viewHeight = viewHeight + 15;
    }
    
    viewHeight = viewHeight + 10;
    
    
    //添加子标题label
    UILabel *subTitleL = [[UILabel alloc] initWithFrame:CGRectMake(15, viewHeight,KAlertViewWidth - 30, [PTTShowAlertView contentHeight:message])];
    subTitleL.textColor = [UIColor blackColor];
    subTitleL.font = [UIFont systemFontOfSize:14];
    subTitleL.text = message;
    subTitleL.textAlignment = NSTextAlignmentCenter;
    subTitleL.numberOfLines = 0;
    [rootV addSubview:subTitleL];
    
    //计算子标题高度
    viewHeight = viewHeight + [PTTShowAlertView contentHeight:message] + 10;
    
    //添加下方按钮  如果两个按钮都有值
    if (cancelTitle && sureTitle) {
        
        UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [canceButton setTitle:cancelTitle forState:UIControlStateNormal];
        [canceButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        canceButton.layer.borderWidth = 1;
        canceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        canceButton.frame = CGRectMake(-1, viewHeight, KAlertViewWidth/2 + 1, 41);
        [rootV addSubview:canceButton];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [sureButton setTitle:sureTitle forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        sureButton.frame = CGRectMake(KAlertViewWidth/2 - 1, viewHeight, KAlertViewWidth/2 + 2, 41);
        sureButton.layer.borderWidth = 1;
        sureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rootV addSubview:sureButton];
        
        viewHeight = viewHeight + 40;
    }else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:cancelTitle?cancelTitle:sureTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(-1, viewHeight, KAlertViewWidth + 2, 41);
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rootV addSubview:button];
        
        viewHeight = viewHeight + 40;
        _cancelAction = cancelBlock?cancelBlock:sureBlock;
    }
    
    rootV.frame = CGRectMake(kWindowWidth/2 - KAlertViewWidth/2, kWindowHeight/2 - viewHeight/2, KAlertViewWidth, viewHeight);
    [PTTMaskManager pttAddMaskWithView:rootV delegaete:delegate];
}

+(void)clickCancelBtn{
    
    [PTTMaskManager pttRemoveMask];
    if (_cancelAction) {
        
        _cancelAction();
    }
}

+(void)clickSureBtn{
    
    [PTTMaskManager pttRemoveMask];
    if (_sureAction) {
        _sureAction();
    }
}

+(CGFloat)contentHeight:(NSString*)content{
    
    if (content.length == 0) {
        return 0;
    }
    
    CGRect newRect =   [content boundingRectWithSize:CGSizeMake(KAlertViewWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return  newRect.size.height;
}

/**
 弹出系统的提示框
 
 *  @param title       描述文本
 *  @param cancelTitle 取消按钮标题
 *  @param cancelBlock 取消按钮调用Block块
 *  @param sureTitle   确定按钮标题
 *  @param sureBlock   确定按钮调用block块
 */
+(void)showSystemAlsertViewWithTitle:(NSString*)title message:(NSString*)message cancleBtnTitle:(NSString*)cancelTitle cancelAction:(void (^)())cancelBlock sureBtnTitle:(NSString*)sureTitle sureAction:(void (^)())sureBlock viewController:(UIViewController*)viewController{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* sure;
    if (sureTitle) {
        
       sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         if (sureBlock) {
                                                             sureBlock();
                                                         }
                                                     }];
    }
    
   
    UIAlertAction* cancel;
    if (cancelTitle) {
        
        cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          if (cancelBlock) {
                                              cancelBlock();
                                          }
                                      }];
    }
    
    if (sure) {
        [alert addAction:sure];
    }
    if (cancel) {
        [alert addAction:cancel];
    }
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
