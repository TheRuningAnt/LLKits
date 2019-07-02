

//
//  PTTGuideView.m
//  goldNews-iOS
//
//  Created by 赵广亮 on 2016/12/16.
//  Copyright © 2016年 zhaoguangliang. All rights reserved.
//

#import "PTTGuideView.h"
//屏幕宽高
#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight ([[UIScreen mainScreen] bounds].size.height)

@interface PTTGuideView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation PTTGuideView
/**
 添加引导图到视图上方
 
 @param imageNames 图片数组
 @return 引导图
 */
-(instancetype)initWithGuiderWithImageNames:(NSArray*)imageNames{
   
    if (!imageNames) {
        
        return nil;
    }
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
    
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.contentSize = CGSizeMake(kWindowWidth * imageNames.count, kWindowHeight);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kWindowHeight - 30, kWindowWidth, 24)];
        _pageControl.numberOfPages = imageNames.count;
        _pageControl.currentPage = 0;
       // [self addSubview:_pageControl];
        
        self.frame = [UIScreen mainScreen].bounds;
        
        //循环添加图片
        for (int i = 0; i < imageNames.count; i ++) {
            
            UIImage *image = [UIImage imageNamed:imageNames[i]];
            UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
            imageV.frame = CGRectMake(kWindowWidth * i, 0, kWindowWidth, kWindowHeight);
            
            [_scrollView addSubview:imageV];
        }
        
        //添加移除的 Btn
        UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBtn.frame = CGRectMake((imageNames.count - 1) * kWindowWidth + 30, kWindowHeight - 100, kWindowWidth - 60, 40);
        removeBtn.backgroundColor = [UIColor orangeColor];
        [removeBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        [removeBtn setTitle:@"立即体验" forState: UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:removeBtn];
    }
    return self;
}

//从父类视图移除
-(void)remove{
    
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    _pageControl.currentPage = scrollView.contentOffset.x / kWindowWidth;
}


@end
