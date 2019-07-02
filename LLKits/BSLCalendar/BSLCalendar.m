//
//  BSLCalendar.m
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "BSLCalendar.h"
#import "WeeksView.h"
#import "BSLMonthCollectionView.h"
#import "CalendarModel.h"
//屏幕比例
#define WIDTH_SCALE [[UIScreen mainScreen] bounds].size.width/375.f
#define HEIGHT_SCALE [[UIScreen mainScreen] bounds].size.height/667.f

//屏幕宽高
#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight ([[UIScreen mainScreen] bounds].size.height)
#define CalendarColor [UIColor colorWithRed:240.0/255.0 green:156.0/255.0 blue:40.0/255.0 alpha:1.0]

@interface BSLCalendar ()


@property (nonatomic, strong)WeeksView *weeks;
@property (nonatomic, strong)BSLMonthCollectionView *dayView;

@end


@implementation BSLCalendar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showChineseCalendar = YES;

        [self bsl_controls];
    }
    return self;
}
- (void)setShowChineseCalendar:(BOOL)showChineseCalendar{
    _showChineseCalendar = showChineseCalendar;
    self.dayView.showChineseCalendar = _showChineseCalendar;
}


- (void)selectDateOfMonth:(void (^)(NSInteger, NSInteger, NSInteger))selectBlock{
    [self.dayView setSelectDateBlock:selectBlock];
}

-(void)updateSignDays:(NSArray*)signDays{
    
    __weak typeof(self) weakSelf = self;
    [self.dayView calendarContainerWhereMonth:0 signDays:signDays month:^(MonthModel *month) {
        
        weakSelf.weeks.year = [NSString stringWithFormat:@"%ld年%lu月",month.year,month.month];
    }];
}

- (void)bsl_controls{
    
    [self addSubview:self.weeks];
    [self addSubview:self.dayView];
    
    __weak typeof(self) weakSelf = self;
    [self.dayView calendarContainerWhereMonth:0 signDays:nil month:^(MonthModel *month) {
        weakSelf.weeks.year = [NSString stringWithFormat:@"%ld年%lu月",month.year,month.month];
    }];

    [self.weeks selectMonth:^(BOOL increase) {
       static NSInteger selectNumber = 0;
       static UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCurlUp;
        if (increase) {
            selectNumber = selectNumber + 1;
            animationOption = UIViewAnimationOptionTransitionCurlUp;
        }
        else{
            selectNumber = selectNumber - 1;
            animationOption = UIViewAnimationOptionTransitionCurlDown;

        }
        [UIView transitionWithView:weakSelf.dayView duration:0.8 options:animationOption animations:^{
            [weakSelf.dayView calendarContainerWhereMonth:selectNumber signDays:nil month:^(MonthModel *month) {
                weakSelf.weeks.year = [NSString stringWithFormat:@"%ld",month.year];
            }];
        } completion:nil];
  
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat w = CGRectGetWidth(self.frame);
    self.weeks.frame = CGRectMake(0, 0, w, 70*HEIGHT_SCALE);
    CGFloat dayView_w = CGRectGetWidth(self.weeks.frame);
    CGFloat dayView_h = h - CGRectGetHeight(self.weeks.frame);
    self.dayView.frame = CGRectMake(0, CGRectGetMaxY(self.weeks.frame), dayView_w, dayView_h);
}


- (WeeksView*)weeks{
    if (!_weeks) {
        _weeks = [[WeeksView alloc]initWithFrame:CGRectZero];
        _weeks.backgroundColor = [UIColor whiteColor];
    }
    return _weeks;
}
- (BSLMonthCollectionView *)dayView{
    if (!_dayView) {
        _dayView = [[BSLMonthCollectionView alloc]initWithFrame:CGRectZero];
        _dayView.backgroundColor = [UIColor whiteColor];
    }
    return _dayView;
}
@end

