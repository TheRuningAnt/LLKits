//
//  PTTSignatureView.h
//  goldNews-iOS
//
//  Created by 赵广亮 on 2016/12/14.
//  Copyright © 2016年 zhaoguangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signatureView.h"

@interface PTTSignatureView : UIView
{
    UIImage *saveImage;
    UIView *saveView;
}
@property (strong,nonatomic) signatureView *signatureView;

@property (nonatomic,copy) void (^saveImgAction)(NSString *imageUrl);

@end
