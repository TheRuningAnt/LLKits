//
//  PTTWebViewController.h
//  TestWebView_1102
//
//  Created by 赵广亮 on 2016/11/2.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTWebViewController : PTTBaseViewController

@property (nonatomic,strong) NSString *pttTitle;
@property (nonatomic,strong) NSString *pttUrl;

@property (nonatomic,strong) NSString *htmlStr;
@property (nonatomic,assign) NSInteger ID;  //分享出去的Id

@end
