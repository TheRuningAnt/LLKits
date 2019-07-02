//
//  PttBaseViewController.m
//  PTTNavtionController
//
//  Created by 赵广亮 on 2016/11/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTBaseViewController.h"
#define KWidth [UIScreen mainScreen].bounds.size.width
@interface PTTBaseViewController ()

{
    //导航栏容器视图
    UIView *_backgroundV;
    //导航栏图片视图
    UIImageView *_bacImgeV;
    //导航栏左侧按钮
    UIButton *_leftBtn;
    //导航栏右侧按钮
    UIButton *_rightBtn;
    //导航栏标题label
    UILabel *_titleL;
    //导航栏下方分割线
    UILabel *line;
    
    //左侧按钮触发事件
    void (^_leftAction)();
    //右侧按钮触发事件
    void (^_rigthAction)();
}

@end

@implementation PTTBaseViewController

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //隐藏系统导航栏
    if(self.navigationController){
        
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.navigationBar.translucent = YES;
    }
    
    //添加导航栏
    _backgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, TopSpace,KWidth , 64)];
    _backgroundV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backgroundV];
    
    //如果是iphoneX的话，补上顶部背景视图
    if ([PTTUtil isiPhoneXScreen]) {
        
        UIView *topTmpV = [[UIView alloc] initWithFrame:CGRectMake(0, -TopSpace, kWindowWidth, TopSpace)];
        topTmpV.backgroundColor = [UIColor whiteColor];
        topTmpV.tag = 1002;
        [_backgroundV addSubview:topTmpV];
    }
    
    //添加导航栏背景图片
    _bacImgeV = [[UIImageView alloc] initWithFrame:CGRectMake(0, TopSpace,KWidth , 64)];
    _bacImgeV.contentMode = UIViewContentModeScaleAspectFill;
    _bacImgeV.backgroundColor = [UIColor clearColor];
    [_backgroundV addSubview:_bacImgeV];
    
    //添加左侧按钮
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 45, 44)];
    [_leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundV addSubview:_leftBtn];
    
    //添加导航栏标题
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, kWindowWidth - 120, 44)];
    _titleL.textColor = [UIColor blackColor];
    _titleL.backgroundColor = [UIColor clearColor];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.numberOfLines = 0;
    _titleL.font = [UIFont systemFontOfSize:18];
    [_backgroundV addSubview:_titleL];
    
    //添加下方修饰条
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, KWidth, 0.5f)];
    line.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    line.alpha = 0.1;
    [_backgroundV addSubview:line];
    
    //启用右划返回页面
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];    
}

#pragma mark =================导航栏背景属性=================
/**
 设置导航栏背景图片
 
 @param backgroundImageStr 导航栏背景图片名
 */
-(void)pttSetNavtionBackImageWithImageStr:(NSString*)backgroundImageStr{
    
    _bacImgeV.image = [UIImage imageNamed:backgroundImageStr];
}

/**
 设置导航栏背景颜色
 @param navBackgroundColor 导航栏背景颜色
 */
-(void)pttSetNavBackgroundColor:(UIColor*)navBackgroundColor{
    
    _bacImgeV.backgroundColor = navBackgroundColor;
    _backgroundV.backgroundColor = navBackgroundColor;
    if ([navBackgroundColor isEqual:[UIColor clearColor]]) {
        line.hidden = YES;
    }else{
        
        line.hidden = NO;
    }
}

/**
 设置导航栏透明度
 
 @param alpha 透明度
 */
-(void)pttSetNavtionBarAlpha:(CGFloat)alpha{
    
    _bacImgeV.alpha = alpha;
}

/**
 隐藏整个导航栏
 */
-(void)pttHideNavtionBar{
    
    _backgroundV.hidden = YES;
}

/**
 显示整个导航栏
 */
-(void)pttShowNavtionBar{
    _backgroundV.hidden = NO;
}

/**
 隐藏分割线
 */
-(void)pttHideNavtionLine{
    
    line.hidden = YES;
}

#pragma mark =================导航栏按钮属性=================
/**
 设置左侧按钮的图片和点击事件
 
 @param imgStr 左侧按钮图片名
 @param action 左侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetLeftBtnStr:(NSString*)imgStr action:(void(^)())action{
    
    if (imgStr && imgStr.length > 0) {
     
        [_leftBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateHighlighted];
    }
    _leftAction = action;
}

/**
 设置导航栏自定义左侧按钮,可自定义左侧按钮格式
 
 @param button 左侧按钮
 @param action 左侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetLeftbtn:(UIButton*)button action:(void(^)())action{
    
    if (_leftBtn && _leftBtn.superview && button) {
        
        [_leftBtn removeFromSuperview];
    }
    
    _leftBtn = button;
    _leftAction = action;
    [_backgroundV addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
}

/**
 隐藏左侧返回按钮
 */
-(void)pttHideLeftBtn{
    
    if (_leftBtn) {
        
        _leftBtn.hidden = YES;
    }
}

/**
 设置左侧按钮隐藏属性
 
 @param hide 是否隐藏
 */
-(void)pttSetLeftBtnHide:(BOOL)hide{
    
    if (!_leftBtn) {
        
        return;
    }
    
    _leftBtn.hidden = hide;
}

/**
 设置右侧按钮的图片和点击事件
 
 @param imgStr 右侧按钮图片名
 @param action 右侧按钮点击事件
 */
-(void)pttSetRightBtnStr:(NSString*)imgStr action:(void(^)())action{
    
    if (_rightBtn && _rightBtn.superview) {
        
        [_rightBtn removeFromSuperview];
    }
    
    if (!_rightBtn) {
        
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth - 60, 20, 60, 44)];
        [_backgroundV addSubview:_rightBtn];
    }
    
    [_rightBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    _rigthAction = action;
}

/**
 设置导航栏自定义右侧按钮,可自定义左侧按钮格式
 
 @param button 右侧按钮
 @param action 右侧按钮点击事件 传nil则默认触发返回功能
 */
-(void)pttSetRightbtn:(UIButton*)button action:(void(^)())action{
    
    if (_rightBtn && _rightBtn.superview && !button) {
        
        [_rightBtn removeFromSuperview];
        
        _rightBtn = nil;
        _rigthAction = nil;
        return;
    }
    
    if (_rightBtn && _rightBtn.superview && button) {
        
        [_rightBtn removeFromSuperview];
    }
    
    _rightBtn = button;
    _rigthAction = action;
    if ([_rightBtn isKindOfClass:[UIButton class]] && action) {
        
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    [_backgroundV addSubview:_rightBtn];
}

/**
 设置右侧按钮显示属性  如果有的话
 */
-(void)pttSetRightHide:(BOOL)hide{
    
    if (!_rightBtn) {
        
        return;
    }
    _rightBtn.hidden = hide;
}

#pragma mark =================导航栏标题属性=================
/**
 设置导航栏标题详细属性
 
 @param title 导航栏标题
 @param fontSize 字体大小
 @param fontColor 字体颜色
 @param font  特殊字体,不设定使用系统默认字体
 */
-(void)pttSetNavTitle:(NSString*)title fontSize:(CGFloat)fontSize color:(UIColor*)fontColor font:(UIFont*)font{
    
    if (!font) {
        
        _titleL.font = [UIFont systemFontOfSize:fontSize];
    }else{
        
        if ([font isKindOfClass:[UIFont class]]) {
            
            UIFont *custmFont = (UIFont*)font;
            _titleL.font = [custmFont fontWithSize:fontSize];
        }
    }
    
    _titleL.text = title;
    _titleL.textColor = fontColor;
}

/**
 设置标题
 */
-(void)pttSetTitle:(NSString*)title{
    
    _titleL.text = title;
}

/**
 设置标题颜色
 
 @param titleColor 标题颜色
 */
-(void)pttSetTitleColor:(UIColor*)titleColor{
    
    _titleL.textColor = titleColor;
}

/**
 设置标题位置
 
 @param textAlignment 标题位置
 @param value 距离左右两边的值
 */
-(void)pttsetTitleAlgiment:(NSTextAlignment)textAlignment value:(CGFloat)value{
    
    switch (textAlignment) {
        case NSTextAlignmentLeft:  //左对齐
        {
            _titleL.textAlignment = textAlignment;
            _titleL.frame = CGRectMake(value, 20, kWindowWidth - value, 44);
        }
            break;
        case NSTextAlignmentRight:  //右对齐
        {
            _titleL.textAlignment = textAlignment;
            _titleL.frame = CGRectMake(0, 20, kWindowWidth - value, 44);
        }
            break;
        default:
            break;
    }
}

/**
 添加子视图
 
 @param superView 父类视图
 @param subView 子类视图
 */
-(void)pttView:(UIView*)superView AddSubView:(UIView*)subView{
    
    if (!subView || !superView) {
        
        return;
    }
    
    //如果不隐藏导航栏,则需要将子视图的纵坐标加64
    CGRect frame = subView.frame;
    if (!_backgroundV.hidden) {
        subView.frame = CGRectMake(frame.origin.x, frame.origin.y + 64, frame.size.width, frame.size.height);
    }
    
    [superView addSubview:subView];
}

#pragma mark =================私有方法=================

//左侧按钮点击事件
-(void)clickLeftBtn{
    
    if (_leftAction) {
        
        _leftAction();
        return;
    }
    
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//右侧按钮点击事件
-(void)clickRightBtn{
    
    if (_rigthAction) {
        _rigthAction();
    }
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pttPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.navigationController.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        viewController.hidesBottomBarWhenPushed = YES;
        self.tabBarController.tabBar.hidden = YES;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

/**
 更改当前controller下方的tabBarItem选中和未选中图片
 
 @param normalImgName 未选中图片
 @param selectImgName 选中图片
 */
-(void)pttChangeTabBarNormalImageName:(NSString*)normalImgName selectImageName:(NSString*)selectImgName{
    
    //完全没有未读消息
    UIImage *normalImage = [UIImage imageNamed:normalImgName];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        // 声明这张图片用原图(别渲染)
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIImage *selectImage = [UIImage imageNamed:selectImgName];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        // 声明这张图片用原图(别渲染)
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    self.navigationController.tabBarItem.image = normalImage;   //设置未选中图片
    self.navigationController.tabBarItem.selectedImage = selectImage;   //设置选中图片
}

/**
 设置适配IphoneX顶部图片颜色
 
 @param color 颜色
 */
-(void)pttChangeTopTmpViewBackground:(UIColor*)color{
    
    UIView *view = [_backgroundV viewWithTag:1002];
    if (view) {
        
        view.backgroundColor = color;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
