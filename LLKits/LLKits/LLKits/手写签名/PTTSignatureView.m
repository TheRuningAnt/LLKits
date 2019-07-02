//
//  PTTSignatureView.m
//  goldNews-iOS
//
//  Created by 赵广亮 on 2016/12/14.
//  Copyright © 2016年 zhaoguangliang. All rights reserved.
//

#import "PTTSignatureView.h"
#import "signatureView.h"

@interface PTTSignatureView()<GetSignatureImageDele>

@end

@implementation PTTSignatureView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {

    self.backgroundColor = [UIColor whiteColor];
    
    self.signatureView = [[signatureView alloc] initWithFrame:CGRectMake(0,0, kWindowWidth, kWindowHeight - 60 - 61)];
    self.signatureView.backgroundColor = [UIColor whiteColor];
    self.signatureView.delegate =self;
    
    [self addSubview:self.signatureView];
    
    WK(weakSelf);
    //添加下方的提示bar
    UIView *tipBarBackView = [[UIView alloc] init];
    tipBarBackView.backgroundColor = [UIColor whiteColor];
    tipBarBackView.layer.borderWidth = 0.5;
    tipBarBackView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self addSubview:tipBarBackView];
    [tipBarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.mas_top).offset(6);
        make.left.mas_equalTo(weakSelf.mas_left).offset(15*WIDTH_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-15*WIDTH_SCALE);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
    }];
    
    //添加提示图片
    UIImageView *tipImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"write-singel-tip"]];
    tipImageV.contentMode = UIViewContentModeCenter;
    [tipBarBackView addSubview:tipImageV];
    [tipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(tipBarBackView.mas_left);
        make.top.mas_equalTo(tipBarBackView.mas_top);
        make.bottom.mas_equalTo(tipBarBackView.mas_bottom);
        make.width.mas_equalTo(tipBarBackView.mas_height);
    }];
    
    //添加提示文字
    UILabel *tipL = [[UILabel alloc] init];
    tipL.backgroundColor = [UIColor clearColor];
    tipL.textColor = [UIColor blackColor];
    tipL.font = [UIFont systemFontOfSize:10.f];
    tipL.text = @"温馨提示：请在以下白色区域内手写签名。";
    [tipBarBackView addSubview:tipL];
    [tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(tipImageV.mas_right);
        make.right.mas_equalTo(tipBarBackView.mas_right);
        make.top.mas_equalTo(tipBarBackView.mas_top);
        make.bottom.mas_equalTo(tipBarBackView.mas_bottom);
    }];
    
    //添加下方分割线
    UILabel *lineL = [[UILabel alloc] init];
    lineL.backgroundColor = [UIColor blackColor];
    [self addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-60);
    }];
    
    CGFloat btnWidth = (kWindowWidth - 30 - 40)/3.0;
    
    //添加取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius =5.0;
    cancelButton.clipsToBounds =YES;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelButton.backgroundColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(remove)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(weakSelf.mas_left).offset(15);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-8);
        make.top.mas_equalTo(lineL).offset(8);
        make.width.mas_equalTo(btnWidth);
    }];
    
    //添加清除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清除"forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    button.layer.cornerRadius =5.0;
    button.clipsToBounds =YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(clear:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cancelButton.mas_right).offset(20);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-8);
        make.top.mas_equalTo(lineL).offset(8);
        make.width.mas_equalTo(btnWidth);
    }];
    
    //添加确定按钮
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"确定"forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    button2.backgroundColor = [UIColor cyanColor];
    button2.layer.cornerRadius =5.0;
    button2.clipsToBounds =YES;
    [button2 addTarget:self action:@selector(add:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(button.mas_right).offset(20);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-8);
        make.top.mas_equalTo(lineL).offset(8);
        make.width.mas_equalTo(btnWidth);
    }];
    
    
}

//取消签名
-(void)remove{
    
    if(self.superview){
        
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Register_Animation_Remove" object:nil];
    }
}

//确定当前签名
- (void)add:(UIButton *)sender
{
    [self.signatureView sure];
}

//清除当前的签名
- (void)clear:(UIButton *)sender
{
    NSLog(@"重签");
    [self.signatureView clear];
    for(UIView *view in saveView.subviews)
    {
        [view removeFromSuperview];
    }
}


-(void)getSignatureImg:(UIImage*)image
{
    if(image)
    {
        NSLog(@"haveImage");
        [self putImageToService:image];
    }
    else
    {
        NSLog(@"NoImage");
    }
}

//上传图像至服务器
-(void)putImageToService:(UIImage*)image{

    WK(weakSelf);
//    //创建请求参数
//    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[UserTool userModel].token,@"token",KVersion,@"version",@"ios",@"os",nil];
//    
//    [HttpService sendPostImageHttpRequestWithUrl:API_PutImage paraments:paramentsDic image:image imageName:[PTTDateKit currentDate] successBlock:^(NSDictionary *jsonDic) {
//        
//        if([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]){
//            
//            NSDictionary *dataDic= [jsonDic objectForKey:@"data"];
//            if (dataDic && dataDic.count != 0) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    NSString *serviceImageUrl = [dataDic objectForKey:@"url"];
//                    if (weakSelf.saveImgAction) {
//                        
//                        weakSelf.saveImgAction(serviceImageUrl);
//                    }
//
//                });
//                
//            }
//        }else{
//            
//            [ShowMessageTipUtil showTipLabelWithMessage:@"图片上传失败" spacingWithTop:kWindowHeight/4*3 stayTime:2];
//        }
//    }];
}

@end
