//
//  PTTCycleSrollView.m
//  TestScrollView
//
//  Created by 赵广亮 on 2016/10/15.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTCycleSrollView.h"
#import "UIImageView+PTT.h"
#import "UIImageView+WebCache.h"

@interface PTTCycleSrollView()<UIScrollViewDelegate>

//数据定义
@property (nonatomic,strong) NSArray *localImagesName;         //本地图片名数组
@property (nonatomic,strong) NSArray *imageUrls;               //网络图片链接数组
@property (nonatomic,strong) NSMutableArray *imageViews;       //轮播图使用图片数组
@property (nonatomic,strong) NSArray *imageDescribes;          //图片描述
@property (nonatomic,assign) int currentIndex;                 //当前图片下标
@property (nonatomic,strong) NSString *placeholderImage;       //占位图名
@property (nonatomic,assign) CGFloat height;                   //轮播图高度
@property (nonatomic,assign) CGRect leftRect;                  //左侧视图frame
@property (nonatomic,assign) CGRect rightRect;                 //中间视图frame
@property (nonatomic,assign) CGRect midect;                    //右侧视图frame
@property (nonatomic,strong) NSTimer *timer;                   //使用定时器
@property (nonatomic,assign) CGFloat timeInterval;             //定时器时间间隔
@property (nonatomic,assign) BOOL autoRun;                     //是否自动轮播
@property (nonatomic,assign) BOOL showPageControl;             //是否显示pageControl
@property (nonatomic,assign) PTT_PAGE_CONTROL_ALIGNMENT pageControlAlignment;  //pageControl对齐方式

@property (nonatomic,assign) CGFloat scrollView_Width;         //轮播图宽度
@property (nonatomic,assign) CGFloat scrollView_Height;        //轮播图高度

//控件声明
@property (nonatomic,strong) UIScrollView *pttScrollView;      //轮播图
@property (nonatomic,strong) UIPageControl *pttPageControl;    //图片指示器

@end

@implementation PTTCycleSrollView

#pragma mark 对外接口

//使用本地图片数组初始化
-(instancetype)initCycleScrollViewWithLocalImages:(NSArray*)imageNames frame:(CGRect)frame autoRun:(BOOL)autoRun timeInterval:(CGFloat)timeInterval showPageControl:(BOOL)showPageControl pageControlAlignment:(PTT_PAGE_CONTROL_ALIGNMENT)pageControlAlignment{
    
    if (self = [super initWithFrame:frame]) {
        self.localImagesName = imageNames;
        self.backgroundColor = [UIColor whiteColor];
        self.height = self.frame.size.height;
        self.showPageControl = showPageControl;
        self.pageControlAlignment = pageControlAlignment;
        self.scrollView_Width = frame.size.width;
        self.scrollView_Height = frame.size.height;
        if (autoRun) {
            self.autoRun = autoRun;
            self.timeInterval = timeInterval;;
        }
        
        [self initializeData];
        [self setupUI];
    }
    
    return self;
}

//使用网络图片加载
-(instancetype)initCycleScrollViewWithUrlImages:(NSArray*)urls placeHolderName:(NSString*)placeHolderName frame:(CGRect)frame autoRun:(BOOL)autoRun timeInterval:(CGFloat)timeInterval showPageControl:(BOOL)showPageControl pageControlAlignment:(PTT_PAGE_CONTROL_ALIGNMENT)pageControlAlignment{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.imageUrls = urls;
        self.placeholderImage = placeHolderName;
        self.backgroundColor = [UIColor whiteColor];
        self.height = self.frame.size.height;
        self.showPageControl = showPageControl;
        self.pageControlAlignment = pageControlAlignment;
        self.scrollView_Width = frame.size.width;
        self.scrollView_Height = frame.size.height;
        if (autoRun) {
            self.autoRun = autoRun;
            self.timeInterval = timeInterval;;
        }
        
        [self initializeData];
        [self setupUI];
    }
    
    return self;
}

/**
 *  使用给定的网络图片数组和描述数组来更新scrollView   目前只考虑到网络图片数据更新问题  本体图片数据二次更新待检测!!!
 *
 *  @param urls         图片链接数组 (NSString)
 *  @param descriptions 描述数组    (NSString)
 */
-(void)updataWithImageUrls:(NSArray*)urls andDescriptions:(NSArray*)descriptions{
    
    [self.timer invalidate];   //更新数据时停止定时器触发
    [self.imageViews removeAllObjects];
    
    if (!urls) {
        return;
    }
    
    self.imageUrls = urls;
    self.imageDescribes = descriptions;
    
    __weak typeof (self) weakSelf = self;
    [self.imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithframe:self.frame andImageUrl:obj palaceolderImage:self.placeholderImage contendMode:PTT_ImageView_Image_Contend_Mode_Fill withAction:^(id sender) {
            if(weakSelf.imageUrls.count == 2 || weakSelf.localImagesName.count == 2){
                if (weakSelf.currentIndex  > 1) {
                    [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex - 2];
                }else{
                    [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex];
                }
            }else{
                [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex];
            }
        }];
        [self.imageViews addObject:imageView];
    }];

    NSArray *oldSubViews = [self.pttScrollView.subviews copy];
    [oldSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView*)obj  removeFromSuperview];
        }
    }];
    
    [self setupScrollViewSubViewoOriginal];     //更新轮播图的数据
    
    [self changePageControlValue];              //更新页面指示器的数据
    
    //根据给的图片大小来为图片添加文本
    if (self.imageUrls.count == 2 || self.localImagesName.count == 2) {  //如果是两张图片的特殊情况
        [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(addDescribe:)]) {
                if (weakSelf.imageDescribes && weakSelf.imageDescribes.count > idx%2) {
                    [obj addDescribe:weakSelf.imageDescribes[idx%2]];
                }
            }
        }];
    }else{
        [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(addDescribe:)]) {
                
                if (weakSelf.imageDescribes && weakSelf.imageDescribes.count > idx%2) {
                    [obj addDescribe:weakSelf.imageDescribes[idx]];
                }
            }
        }];
    }
    
    //更新数据结束后开启定时器
    if(self.autoRun && ![self.timer isValid]){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeContentOfSet) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    if (urls.count > 1) {
        
        self.pttPageControl.hidden = NO;
    }else{
        
        self.pttPageControl.hidden = YES;
    }
}

#pragma mark 内部调用方法

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

//初始化数据
-(void)initializeData{
    
    __weak typeof (self) weakSelf = self;
    
    //初始化imageViews
    if (self.localImagesName) {         //若是读取本地图片,从本地加载数据
        if (self.localImagesName.count != 0) {
            [self.localImagesName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImageView *imageView = [[UIImageView alloc] initWithframe:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height) andImage:obj contendMode:PTT_ImageView_Image_Contend_Mode_Fill withAction:^(id sender) {
                    
                    [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex];
                }];
                if (imageView.image && imageView) {
                    [weakSelf.imageViews addObject:imageView];
                }
            }];
        }else{
            NSLog(@"本地图片数组为空,初始化失败");
        }
    }else{   //若是读取网络图片,从网络读取数据
        if (self.imageUrls.count != 0) {
            [self.imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                     UIImageView *imageView = [[UIImageView alloc] initWithframe:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height) andImageUrl:obj palaceolderImage:self.placeholderImage contendMode:PTT_ImageView_Image_Contend_Mode_Fill withAction:^(id sender) {
                         if(weakSelf.imageUrls.count == 2 || weakSelf.localImagesName.count == 2){
                             if (weakSelf.currentIndex  > 1) {
                                 [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex - 2];
                             }else{
                                 [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex];
                             }
                         }else{
                                 [weakSelf.pttDelegate cilickAtIndex:weakSelf.currentIndex];
                         }
               }];
                     [self.imageViews addObject:imageView];
            }];
        }else{
            NSLog(@"网络图片链接为空,初始化失败");
        }
    }
    
    //设置srcollView属性
    self.pttScrollView.pagingEnabled = YES;
    self.pttScrollView.bounces = NO;
    
    if (self.autoRun && !self.timer) {
        //初始化定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeContentOfSet) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//布局页面
-(void)setupUI{
    
    WK(weakSelf);
    
    //设置scrollView属性
    self.pttScrollView.contentSize = CGSizeMake(self.scrollView_Width * 3, self.height);
    self.pttScrollView.showsVerticalScrollIndicator = NO;
    self.pttScrollView.showsHorizontalScrollIndicator = NO;
    self.pttScrollView.delegate = self;
    self.pttScrollView.tag = 4000;
    
    [self setupScrollViewSubViewoOriginal];
    [self addSubview:self.pttScrollView];
    
    //设置pageControl属性
    if (self.showPageControl) {
        
        if (self.imageUrls.count == 2 || self.localImagesName.count == 2) {
            self.pttPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, (self.imageUrls.count == 0?self.imageViews.count : self.imageUrls.count) * 5, 30)];
            self.pttPageControl.numberOfPages = self.imageUrls.count;
        }else{
            self.pttPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, (self.imageUrls.count == 0?self.localImagesName.count : self.imageUrls.count) * 5, 30)];
            self.pttPageControl.numberOfPages = self.imageUrls.count == 0?self.localImagesName.count : self.imageUrls.count;
        }
        
        self.pttPageControl.currentPage = 0;
        [self addSubview:self.pttPageControl];
        
        switch (self.pageControlAlignment) {
            case PTT_PAGE_CONTROL_ALIGNMENT_LEFT:
                self.pttPageControl.center = CGPointMake(self.pttPageControl.frame.size.width/2 + 40, self.frame.size.height - 20);
                break;
            case PTT_PAGE_CONTROL_ALIGNMENT_LEFT_MID:
                self.pttPageControl.center = CGPointMake(self.center.x, self.frame.size.height - 20);
                break;
            default :
                self.pttPageControl.center = CGPointMake(self.frame.size.width - self.pttPageControl.frame.size.width/2 - 40, self.frame.size.height - 20);   //默认采用右边布局
                break;
            }
        
        [self addSubview:self.pttPageControl];
    }
}

//修改pageControl属性
-(void)changePageControlValue{
    
    if (self.pttPageControl.superview) {  //如果之前创建过页面指示器  则将其从父视图移除掉
        [self.pttPageControl removeFromSuperview];
        
        if (self.imageUrls.count == 2 || self.localImagesName.count == 2) {
            self.pttPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, (self.imageUrls.count == 0?self.imageViews.count : self.imageUrls.count) * 5, 30)];
            self.pttPageControl.numberOfPages = self.imageUrls.count;
        }else{
            self.pttPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, (self.imageUrls.count == 0?self.imageViews.count : self.imageUrls.count) * 5, 30)];
            self.pttPageControl.numberOfPages = self.imageUrls.count;
        }
        
        self.pttPageControl.currentPage = 0;
        [self addSubview:self.pttPageControl];
    }
    
    switch (self.pageControlAlignment) {
            case PTT_PAGE_CONTROL_ALIGNMENT_LEFT:
                self.pttPageControl.center = CGPointMake(self.pttPageControl.frame.size.width/2 + 40, self.frame.size.height - 20);
                break;
            case PTT_PAGE_CONTROL_ALIGNMENT_LEFT_MID:
                self.pttPageControl.center = CGPointMake(self.center.x, self.frame.size.height - 20);
                break;
            default :
                self.pttPageControl.center = CGPointMake(self.frame.size.width - self.pttPageControl.frame.size.width/2 - 40, self.frame.size.height - 20);   //默认采用右边布局
                break;
    }
}

//修改轮播图内视图位置
-(void)setupScrollViewSubViewoOriginal{
    
    switch (self.imageViews.count) {
        case 0:
            return;
            break;
        case 1:
            
            self.pttScrollView.scrollEnabled = NO;
            ((UIImageView*)(self.imageViews[0])).frame = CGRectMake(self.scrollView_Width, 0, self.scrollView_Width, self.height);
            self.currentIndex = 0;
            
            [self.pttScrollView addSubview:self.imageViews[0]];
            break;
        case 2:
            
        {
            UIImageView *firstImageViewOfCopy = [self.imageViews[0] copy];
            [self.imageViews addObject:firstImageViewOfCopy];
            UIImageView *secondImageViewOfCopy = [self.imageViews[1] copy];
            [self.imageViews addObject:secondImageViewOfCopy];
            
            [self setupScrollViewSubViewoOriginal];
        }
            break;
        default:
            
            ((UIImageView*)(self.imageViews[0])).frame = CGRectMake(self.scrollView_Width, 0, self.scrollView_Width, self.height);
            ((UIImageView*)([self.imageViews lastObject])).frame = CGRectMake(0, 0, self.scrollView_Width, self.height);
            ((UIImageView*)(self.imageViews[1])).frame = CGRectMake(2*self.scrollView_Width, 0, self.scrollView_Width, self.height);
            self.currentIndex = 0;
            
            [self.pttScrollView addSubview:self.imageViews[0]];
            [self.pttScrollView addSubview:self.imageViews[1]];
            [self.pttScrollView addSubview:[self.imageViews lastObject]];
            break;
    }
    self.pttScrollView.contentOffset = CGPointMake(self.scrollView_Width, 0);
}

//定时器更改轮播图显示界面
-(void)changeContentOfSet{

    if (self.imageViews.count <= 1) {
        return;
    }
    [self.pttScrollView setContentOffset:CGPointMake(2*self.scrollView_Width, 0) animated:YES];
}

//设置页面指示器的颜色属性
-(void)pttSetPageControlSelectColor:(UIColor*)selectColor unselectColor:(UIColor*)unselectColor{
    if (self.pttPageControl) {
        
        self.pttPageControl.currentPageIndicatorTintColor = selectColor;
        self.pttPageControl.pageIndicatorTintColor = unselectColor;
    }
}

#pragma mark 懒加载

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

-(UIScrollView *)pttScrollView{
    if (!_pttScrollView) {
        CGRect rect = self.frame;
        rect.origin = CGPointMake(0, 0);
        _pttScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _pttScrollView;
}

#pragma mark UIScrollView代理
//当减速结束后 更改轮播图显示内容
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = self.pttScrollView.contentOffset.x;
    int tmpLeft;
    int tmpMid;
    int tmpRight;
    
    if (offset == 2 * self.scrollView_Width) {  //向左滑动
        self.currentIndex += 1;
        }else if(offset == 0.0){  //向右滑动
        self.currentIndex -= 1;
        }else{
            return;
        }
    
    if ((self.currentIndex == self.imageViews.count)) {
        self.currentIndex = 0;
    }
    if (self.currentIndex < 0) {
        self.currentIndex = (int)(self.imageViews.count - 1);
    }
    
    if (self.currentIndex == self.imageViews.count - 1) {
        ((UIImageView*)(self.imageViews[self.currentIndex - 1])).frame = CGRectMake(0, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[self.currentIndex])).frame = CGRectMake(self.scrollView_Width, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[0])).frame = CGRectMake(2*self.scrollView_Width, 0, self.scrollView_Width, self.height);
        
        tmpLeft = self.currentIndex - 1;
        tmpMid = self.currentIndex;
        tmpRight = 0;
    }else if(self.currentIndex == 0){
        ((UIImageView*)(self.imageViews[self.imageViews.count - 1])).frame = CGRectMake(0, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[0])).frame = CGRectMake(self.scrollView_Width, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[1])).frame = CGRectMake(2*self.scrollView_Width, 0, self.scrollView_Width, self.height);
        
        tmpLeft = (int)self.imageViews.count - 1;
        tmpMid = 0;
        tmpRight = 1;
    }else{
        ((UIImageView*)(self.imageViews[self.currentIndex - 1])).frame = CGRectMake(0, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[self.currentIndex])).frame = CGRectMake(self.scrollView_Width, 0, self.scrollView_Width, self.height);
        ((UIImageView*)(self.imageViews[self.currentIndex + 1])).frame = CGRectMake(2*self.scrollView_Width, 0, self.scrollView_Width, self.height);
        
        tmpLeft = self.currentIndex - 1;
        tmpMid = self.currentIndex;
        tmpRight = self.currentIndex + 1;
    }
    
    NSArray *arrayOfSubviews = self.pttScrollView.subviews;
    [arrayOfSubviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.pttScrollView addSubview:self.imageViews[tmpLeft]];
    [self.pttScrollView addSubview:self.imageViews[tmpMid]];
    [self.pttScrollView addSubview:self.imageViews[tmpRight]];

    self.pttScrollView.contentOffset = CGPointMake(self.scrollView_Width, 0);
    
    if(self.autoRun){
    //拖拽结束停止定时器
    if (!self.timer.isValid) {
       self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeContentOfSet) userInfo:nil repeats:YES];
       [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    }
    
    //每次滚动停止,更新pageControl 当有两张图片时  是特殊情况
    if(self.showPageControl){
        if (self.imageUrls.count == 2 || self.localImagesName.count == 2) {
            self.pttPageControl.currentPage = self.currentIndex % 2;
        }else{
            self.pttPageControl.currentPage = self.currentIndex;
        }
    }
}

//从主视图移除
-(void)removeFromSuperview{
    
    [super removeFromSuperview];
    [self.timer invalidate];   //停止定时器触发
    [self.imageViews removeAllObjects];
    
    NSArray *oldSubViews = [self.pttScrollView.subviews copy];
    [oldSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView*)obj  removeFromSuperview];
        }
    }];
}

//开始拖拽的时候停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(self.autoRun){
        [self.timer  invalidate];
    }
}

@end
