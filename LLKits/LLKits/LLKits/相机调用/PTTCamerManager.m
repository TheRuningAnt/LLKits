

//
//  PTTCamerManager.m
//  TestCanmer
//
//  Created by 赵广亮 on 2017/2/18.
//  Copyright © 2017年 zhaoguangliang. All rights reserved.
//

#import "PTTCamerManager.h"

@interface PTTCamerManager()<UIImagePickerControllerDelegate,UIAlertViewDelegate>

/**
 图片选择器
 */
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

/**
 代理控制器
 */
@property (nonatomic,strong) UIViewController *delegateVC;

/**
 是否显示照片截取框
 */
@property (nonatomic,assign) BOOL showEditFrame;

/**
 获取照片之后的action
 */
@property (nonatomic,copy) void (^myAction)(UIImage *image);

@end

@implementation PTTCamerManager

/**
 调用系统相机，并返回获取到的照片
 
 @param deleageteVC 调用相机的viewController
 @return PTTCamerManager
 */
-(instancetype)initWithVC:(UIViewController*)deleageteVC{
    
    self = [super init];
    if (self) {
        
        _delegateVC = deleageteVC;
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [_imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationbar_background"] forBarMetrics:UIBarMetricsDefault];
        _imagePickerController.delegate = self;
        [_imagePickerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    return self;
}

/**
 调用相机方法
 
 @param cameraType 相机类型
 @param showEditFrame 是否显示图片选取框
 @param action 选取图片之后的action
 */
-(void)callTheCameraWithType:(CameraType)cameraType showEditFrame:(BOOL)showEditFrame aciton:(void (^)(UIImage *image))action{
    
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //是否显示图片选择框
    _showEditFrame = showEditFrame;
    _imagePickerController.allowsEditing = showEditFrame;
    
    //获取action
    _myAction = action;
    
    if (cameraType == KCamera_and_album) {
        
        [avatarAlert addAction:[UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            if (_delegateVC) {
                
                [_delegateVC presentViewController:_imagePickerController animated:YES completion:nil];
            }else{
                
                NSLog(@"相机代理controller不存在");
            }
        }]];
        
        [avatarAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (_delegateVC) {
                
                [_delegateVC presentViewController:_imagePickerController animated:YES completion:nil];
            }else{
                
                NSLog(@"相机代理controller不存在");
            }
        }]];
    }
    
    if (cameraType == KCamera_only) {
        
        [avatarAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (_delegateVC) {
                
                [_delegateVC presentViewController:_imagePickerController animated:YES completion:nil];
            }else{
                
                NSLog(@"相机代理controller不存在");
            }
        }]];
    }
    
    if (cameraType == KAlbum_only) {
        
        [avatarAlert addAction:[UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (_delegateVC) {
                
                [_delegateVC presentViewController:_imagePickerController animated:YES completion:nil];
            }else{
                
                NSLog(@"相机代理controller不存在");
            }
        }]];
    }
    
    [avatarAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nullable action) {}]];
    
    if (_delegateVC) {
        
        [_delegateVC presentViewController:avatarAlert animated:YES completion:nil];
    }else{
        
        NSLog(@"相机代理controller不存在");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。

    /*
     UIImagePickerControllerOriginalImage  //获取原图片
     UIImagePickerControllerEditedImage    //获取编辑框截取后的图片
     */
    UIImage *photo;
    if (_showEditFrame) {

        photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{

        photo = [info objectForKey:UIImagePickerControllerEditedImage];
    }

    if (photo && _myAction) {

        _myAction(photo);
    }

    if (_delegateVC) {

        [_delegateVC dismissViewControllerAnimated:YES completion:nil];
    }else{

        NSLog(@"相机代理controller不存在");
    }
}

@end
