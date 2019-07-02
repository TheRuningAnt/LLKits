//
//  UIImageView+PTTCate.m
//  PTTFramework
//
//  Created by 赵广亮 on 2016/10/15.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "UIImageView+PTT.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static const int target_key;
static const int local_image_name;  //保存加载本地图片名
static const int image_url;         //保存图片链接
static const int placeholder_image; //占位图

//定义处理任务对象
@interface _PTTImageViewTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _PTTImageViewTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

//调用Block
- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

//更新Block
-(void)changeblock:(void (^)(id sender))block{
    _block = [block copy];
}

@end

@implementation UIImageView (PTT)


/**
 *  创建UIImageView+PTTCate对象  从本地读取图片
 *
 *  @param frame       imageView尺寸
 *  @param imageName   图片名
 *  @param contendMode 填充模式
 *  @param block       事件处理Block
 *
 *  @return UIImageView+PTTCate对象
 */
-(instancetype)initWithframe:(CGRect)frame andImage:(NSString *)imageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode withAction:(void (^)(id sender))block{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            self.image = image;
        }else{
            NSLog(@"本地加载图片为空");
        }
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = (UIViewContentMode)contendMode;
        objc_setAssociatedObject(self, &local_image_name, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);  //保存当前加载的本地图片名
        
        [self bindTarget:block];
        [self addTapGestureRecognizerWithBlock:block];
    }
    return self;
}

/**
 *  从网络读取图片创建UIImageView+PTTCate对象
 *
 *  @param frame          imageView尺寸
 *  @param imageUrl       图片网络链接
 *  @param placeImageName 占位图名字(本地)
 *  @param contendMode    填充模式 (图片本身大小/拉伸图片适应UIImageView)
 *  @param block          事件处理Block
 *
 *  @return UIImageView+PTTCate对象
 */
-(instancetype)initWithframe:(CGRect)frame andImageUrl:(NSString *)imageUrl palaceolderImage:(NSString*)placeImageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode withAction:(void (^)(id sender))block{
    
    if (!imageUrl) {
        NSLog( @"图片网络链接不能为空");
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        if (placeImageName.length > 0) {
            
            UIImage *image = [UIImage imageNamed:placeImageName];
            [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
        }else{
            
            [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }

        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = (UIViewContentMode)contendMode;
        self.clipsToBounds = YES;
        objc_setAssociatedObject(self, &image_url, imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &placeholder_image, placeImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self bindTarget:block];
        [self addTapGestureRecognizerWithBlock:block];
    }
    return self;
}

/**
 *  使用本地图片和标题创建一个上面图片下面标题的ImageView对象
 *
 *  @param frame     尺寸
 *  @param imageName 本地图片名
 *  @param title     标题
 *  @parm  color     标题颜色
 *  @param block     回调
 *
 *  @return ImageView对象
 */
-(instancetype)initWithFrame:(CGRect)frame localImage:(NSString*)imageName contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode title:(NSString*)title fontSize:(NSInteger)fontSize titleColor:(UIColor*)titleColor withAction:(void (^)(id sender))block{
    
    UIImageView *subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 30)];
    if (subImageView) {
        subImageView.image = [UIImage imageNamed:imageName];
        subImageView.contentMode = (UIViewContentMode)contendMode;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, subImageView.frame.size.height, subImageView.frame.size.width, 30)];
    label.text = title;
    label.textColor = titleColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:subImageView];
        [self addSubview:label];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self bindTarget:block];
    [self addTapGestureRecognizerWithBlock:block];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame localImage:(NSString*)imageName imageFrame:(CGRect)imageFrame contendMode:(PTT_ImageView_Image_Contend_Mode)contendMode title:(NSString*)title fontSize:(NSInteger)fontSize titleColor:(UIColor*)titleColor distantWithImageAndTitle:(CGFloat)distant withAction:(void (^)(id sender))block{
    
    self = [super initWithFrame:frame];
    
    UIImageView *subImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    if (subImageView) {
        subImageView.image = [UIImage imageNamed:imageName];
        subImageView.contentMode = (UIViewContentMode)contendMode;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subImageView.frame) + distant, self.frame.size.width, 30)];
    
    label.text = title;
    label.textColor = titleColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self) {
        [self addSubview:subImageView];
        [self addSubview:label];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self bindTarget:block];
    [self addTapGestureRecognizerWithBlock:block];
    
    return self;
}

/**
 *  为创建好的UIImageView添加事件处理Block 将会更新原Block
 *
 *  @param instancetype 事件处理Block
 *
 */
-(void)addAction:(void (^)(id sender))block{
    
    [self bindTarget:block];
}

/**
 *  设置图片位置,以左上角为准
 *
 *  @param origin 左上角位置
 */
-(void)setOrigin:(CGPoint)origin{
    
    CGRect rect = CGRectMake(origin.x, origin.y, self.frame.size.width , self.frame.size.height);
    self.frame = rect;
}


/**
 *  为图片添加描述
 *
 *  @param describe 描述文本
 */
-(void)addDescribe:(NSString*)describe{
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 30, self.frame.size.width - 100, 30)];
//    textView.text = describe;
//    textView.textColor = [UIColor whiteColor];
//    textView.backgroundColor = [UIColor clearColor];
//    textView.font = [UIFont systemFontOfSize:17];
//    textView.editable = NO;
//
//    [self addSubview:textView];
    
    if (describe.length == 0) {
        
        return;
    }
    
    //添加底部阴影蒙版  默认隐藏
    UIImageView *shadowImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll-shaow-back"]];
    shadowImageV.tag = 4001;
    shadowImageV.hidden = NO;
    [self addSubview:shadowImageV];
    shadowImageV.frame = CGRectMake(0,  self.frame.size.height - 37*HEIGHT_SCALE, self.frame.size.width, 37*HEIGHT_SCALE);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 35, self.frame.size.width - 120, 30)];
    label.text = describe;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];

    [self addSubview:label];
    
}

#pragma mark 内部调用的方法

//绑定消息处理对象
-(void)bindTarget:(void (^)(id sender))block{
    
    _PTTImageViewTarget *target = objc_getAssociatedObject(self, &target_key);
    if (target) {
        [target changeblock:block];
    }else{
        target = [[_PTTImageViewTarget alloc] initWithBlock:block];
        objc_setAssociatedObject(self, &target_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

//设置处理点击事件
-(void)addTapGestureRecognizerWithBlock:(void (^)(id sender))block{
    
    _PTTImageViewTarget *target = objc_getAssociatedObject(self, &target_key);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(invoke:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}


-(id)copy{
    
    _PTTImageViewTarget *target = objc_getAssociatedObject(self, &target_key);
    if (!target) {
        return nil;
    }
    
    UIImageView *imageViewOfCopy;
    NSString *imageUrl = objc_getAssociatedObject(self, &image_url);
    
    //根据当前链接判断是否是网络加载图片
    if (imageUrl) {
        
        NSString *placeholderImage = objc_getAssociatedObject(self, &placeholder_image);
        imageViewOfCopy = [[UIImageView alloc] initWithframe:self.frame andImageUrl:imageUrl palaceolderImage:placeholderImage contendMode:(PTT_ImageView_Image_Contend_Mode)(self.contentMode) withAction:target.block];
    }else{
        NSString *localImageName = objc_getAssociatedObject(self, &local_image_name); //如果从本地读取不到图片,则加载默认图片
        imageViewOfCopy = [[UIImageView alloc] initWithframe:self.frame andImage:localImageName contendMode:(PTT_ImageView_Image_Contend_Mode)(self.contentMode) withAction:target.block];
    }
    return imageViewOfCopy;
}

@end
