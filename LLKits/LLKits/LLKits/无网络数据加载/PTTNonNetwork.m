//
//  PTTNonNetwork.m
//  goldNews-iOS
//
//  Created by 赵广亮 on 2017/1/7.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import "PTTNonNetwork.h"

@interface PTTNonNetwork()

@property (nonatomic,copy) void (^_action)();

@end

@implementation PTTNonNetwork

/**
 创建无网络时的提示页面,点击刷新按钮重新发起网络请求
 
 @param frame frame
 @param backgroundColor 背景颜色
 @param action 点击刷新按钮回调事件
 @return 无网络加载页面
 */
-(instancetype)initWithFrame:(CGRect)frame backGroundColor:(UIColor*)backgroundColor action:(void (^)())action{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (backgroundColor) {
            
            self.backgroundColor = backgroundColor;
        }
        
        __action = action;
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    //设置无网络提示图片
    UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-network"]];
    tipImageView.contentMode= UIViewContentModeCenter;
    [self addSubview:tipImageView];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200*WIDTH_SCALE,190*HEIGHT_SCALE));
    }];
    
    //添加刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    refreshBtn.backgroundColor = [UIColor cyanColor];
    refreshBtn.layer.masksToBounds = YES;
    refreshBtn.layer.cornerRadius = 5;
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(tipImageView.mas_bottom).offset(24*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(110*WIDTH_SCALE);
        make.height.mas_equalTo(35*HEIGHT_SCALE);
    }];
}

-(void)clickRefreshBtn{
    
    if (__action) {
        
        __action();
    }
}

@end
