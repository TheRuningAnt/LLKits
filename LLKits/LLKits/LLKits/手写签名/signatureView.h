//
//  signatureView.h
//  SignProduct
//
//  Created by ptteng on 16/11/12.
//  Copyright © 2016年 ptteng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GetSignatureImageDele <NSObject>

-(void)getSignatureImg:(UIImage*)image;

@end


@interface signatureView : UIView
{
    CGFloat min;
    CGFloat max;
    CGRect origRect;
    CGFloat origionX;
    CGFloat totalWidth;
    BOOL  isSure;
}
//签名完成后的水印文字
@property (strong,nonatomic) NSString *showMessage;
@property(nonatomic,assign)id<GetSignatureImageDele> delegate;
- (void)clear;
- (void)sure;
@end
