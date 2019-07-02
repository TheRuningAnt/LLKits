//
//  WeeksView.m
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "WeeksView.h"
//屏幕比例
#define WIDTH_SCALE [[UIScreen mainScreen] bounds].size.width/375.f
#define HEIGHT_SCALE [[UIScreen mainScreen] bounds].size.height/667.f

//屏幕宽高
#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight ([[UIScreen mainScreen] bounds].size.height)
@interface WeeksView ()

@property (nonatomic, strong)NSMutableArray *labsArray;
@property (nonatomic, strong)UIButton *lastButton;
@property (nonatomic, strong)UIButton *nextButton;
@property (nonatomic, strong)UILabel *yearLabel;


@property (nonatomic, copy)void((^selectMonthBlock)(BOOL increase));


@end
@implementation WeeksView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self bsl_controls];
    }
    return self;
}
- (void)bsl_controls{
    
//    [self addSubview:self.lastButton];
//    [self addSubview:self.nextButton];
    [self addSubview:self.yearLabel];
    [self.lastButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (NSString *title in weekArray)  {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labsArray addObject:label];
    }
}

- (void)selectMonth:(void (^)(BOOL increase))selectBlock{
    self.selectMonthBlock = selectBlock;
}

- (void)setYear:(NSString *)year{
    _year = year;
    if (!_year) return;
        
    self.yearLabel.text = _year;
}

- (void)buttonClick:(UIButton*)btn{
    BOOL increase = NO;
    switch (btn.tag) {
        case 100:
            increase = NO;
            break;
        case 200:
            increase = YES;
            break;
            
        default:
            break;
    }
    if (self.selectMonthBlock) {
        self.selectMonthBlock(increase);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    
    CGFloat btn_maginTop = 5.0f;
    CGFloat btn_maginleft = 5.0f;
    CGFloat btn_h = 15.0f;
    CGFloat btn_w = (w-2*btn_maginleft)*0.4;
    self.lastButton.frame = CGRectMake(btn_maginleft, btn_maginTop, btn_w, btn_h);
    CGFloat next_maginleft = w - 2*(btn_w+btn_maginleft)+CGRectGetMaxX(self.lastButton.frame);
    self.nextButton.frame = CGRectMake(next_maginleft, btn_maginTop, btn_w, btn_h);
    self.yearLabel.frame = CGRectMake(0, 0,  w, 40*HEIGHT_SCALE);

    for (int i = 0; i < self.labsArray.count; ++i) {
        UILabel *label = self.labsArray[i];
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.frame = CGRectMake(i * (w/7.0), 40*HEIGHT_SCALE, w/7.0, 30*HEIGHT_SCALE);
//        label.layer.masksToBounds = YES;
        
        if (i == 0 || i == 6) {
            
            CGFloat radius = 5;
            
            UIRectCorner rectType = UIRectCornerTopLeft;
            if (i == 6) {
                
                 rectType = UIRectCornerTopRight;
            }
            
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:rectType cornerRadii:CGSizeMake(radius, radius)];
            CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
            mask.lineWidth = 0.3;
            mask.lineCap = kCALineCapSquare;
            
            // 带边框则两个颜色不要设置成一样即可
            mask.strokeColor = [UIColor lightGrayColor].CGColor;
            mask.fillColor = [UIColor clearColor].CGColor;

            mask.path = path.CGPath;
            label.layer.borderColor = [UIColor clearColor].CGColor;
            [label.layer addSublayer:mask];
        }
    }
}
- (NSMutableArray*)labsArray{
    if (!_labsArray) {
        _labsArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _labsArray;
}
- (UIButton *)lastButton{
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setTitle:@"上一月" forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _lastButton.backgroundColor = [UIColor whiteColor];
        _lastButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _lastButton.tag = 100;
        _lastButton.frame = CGRectZero;
    }
    return _lastButton;
}
- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一月" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _nextButton.backgroundColor = [UIColor whiteColor];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _nextButton.tag = 200;
        _nextButton.frame = CGRectZero;
    }
    return _nextButton;
}
- (UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _yearLabel.textColor = [UIColor blackColor];
        _yearLabel.font = [UIFont systemFontOfSize:16];
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.text = @"2017";
    }
    return _yearLabel;
}

@end
