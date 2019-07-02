//
//  PTTGestureLock.m
//  TestGesture_1126
//
//  Created by 赵广亮 on 2016/11/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTGestureLockV.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface PTTGestureLockV()

@property (nonatomic,strong)NSMutableArray *buttonArr; //全部手势按键的数组
@property (nonatomic,strong)NSMutableArray *selectorArr;//选中手势按键的数组
@property (nonatomic,assign)CGPoint startPoint;//记录开始选中的按键坐标
@property (nonatomic,assign)CGPoint endPoint;//记录结束时的手势坐标
@property (nonatomic,strong)UIImageView *imageView;//画图所需
@property (nonatomic,strong)NSMutableArray *resultsMutArr;

@property (nonatomic,copy) void (^returnResult)(NSArray* secrets);

@end

@implementation PTTGestureLockV

/**
 创建手势解锁页面
 
 @param frame  frame
 @param action 回调Blck
 param secrets 当前选择图案对应数组, NSArray(NSNumber)
 @return PTTGestureLock
 */
-(instancetype)initWithFrame:(CGRect)frame Block:(void (^)(NSArray* secrets))action{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        if (action) {
            _returnResult = action;
        }
    }
    return self;
}

#pragma mark 私有方法

-(void)setUpUI{
    
    //初始化数据
    _buttonArr = [[NSMutableArray alloc]initWithCapacity:9];
    _resultsMutArr = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addSubview:self.imageView];
    
    int tag = 1;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth/12+ScreenWidth/3*j, ScreenHeight/3+ScreenWidth/3*i, ScreenWidth/6, ScreenWidth/6);
            [btn setImage:[UIImage imageNamed:@"non_select"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateHighlighted];
            btn.userInteractionEnabled = NO;
            btn.tag = tag ++;
            [self.buttonArr addObject:btn];
            [self.imageView addSubview:btn];
        }
    }
}


/**
 移动的时候会划线,如果是最后一次划线 ,则只绘制按钮之间的连接线
 
 @param isEnd 手指是否已经离开屏幕
 @return 绘制好的路径 Image
 */
-(UIImage *)drawLineWhetherEnd:(BOOL)isEnd{
    UIImage *image = nil;
    
    if (_selectorArr.count == 0) {
        return nil;
    }
    
    UIColor *col = [UIColor redColor];
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小为imageview的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 15);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, col.CGColor);
    
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);//设置画线起点
    
    //从起点画线到选中的按键中心，并切换画线的起点
    for (UIButton *btn in self.selectorArr) {
        CGPoint btnPo = btn.center;
        CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
        CGContextMoveToPoint(context, btnPo.x, btnPo.y);
    }
    //画移动中的最后一条线
    if (!isEnd) {
        
        CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    }
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();//画图输出
    UIGraphicsEndImageContext();//结束画线
    return image;
}

//开始手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = nil;
    self.selectorArr = nil;
    for (UIButton *btn in self.buttonArr) {
        btn.highlighted = NO;
    }
    
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        
        for (UIButton *btn in self.buttonArr) {
            
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
                
                [self.selectorArr addObject:btn];
                btn.highlighted = YES;
                self.startPoint = btn.center;//保存起始坐标
            }
        }
    }
}

//移动中触发，画线过程中会一直调用画线方法
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        
        self.endPoint = [touch locationInView:self.imageView];
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];
            
            //当触摸坐标在某一个按钮上时,判断该按钮是否已经添加到已选择按钮数组里
            if ([btn pointInside:po withEvent:nil]) {
                
                BOOL needAdd = YES;//记录是否为重复按键
                for (UIButton *seBtn in self.selectorArr) {
                    if (seBtn == btn) {
                        needAdd = NO;//已经是选中过的按键，不再重复添加
                        break;
                    }
                }
                
                //判断是否要添加中间的按钮
                if (needAdd) {
                    
                    [self addOtherLineWithSelectBtn:btn];
                }
                
                if (needAdd) {//未添加的选中按键，添加并修改状态
                    [self.selectorArr addObject:btn];
                    btn.highlighted = YES;
                }
            }
        }
    }
    
    self.imageView.image = [self drawLineWhetherEnd:0];//每次移动过程中都要调用这个方法，把画出的图输出显示
}

//手势结束触发
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (_selectorArr.count > 0) {
        
        //初始化回调数据
        [_resultsMutArr removeAllObjects];
        
        [_selectorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton*)obj;
                
                [_resultsMutArr addObject:[NSNumber numberWithInteger:button.tag]];
            }
        }];
        
        //执行回调方法
        if (_returnResult) {
            
            _returnResult(_resultsMutArr);
        }
    }
    
    self.imageView.image = [self drawLineWhetherEnd:1];
}


//根据当选择按钮以及已经选中按钮的数组,判断是否将中间的按钮链接起来
-(void)addOtherLineWithSelectBtn:(UIButton*)btn{
    
    if (!btn) {
        return;
    }
    
    if (self.selectorArr.count && self.selectorArr.count < 1) {
        return;
    }
    
    if (btn) {
        
        NSInteger tag = btn.tag;
        UIButton *lastBtn = [self.selectorArr lastObject];
        NSInteger lastSelectIndex = lastBtn.tag;
        
        //上个选择的按钮tag为1
        if (lastSelectIndex == 1) {
            
            switch (tag) {
                case 3:
                    if (![self selectArrayContainBtnOfTag:2]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:2];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 7:
                    if (![self selectArrayContainBtnOfTag:4]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:4];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 9:
                    if (![self selectArrayContainBtnOfTag:5]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:5];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
               }
           }
        
        //上个选择的按钮tag为3
        if (lastSelectIndex == 3) {
            
            switch (tag) {
                case 1:
                    if (![self selectArrayContainBtnOfTag:2]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:2];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 7:
                    if (![self selectArrayContainBtnOfTag:5]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:5];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 9:
                    if (![self selectArrayContainBtnOfTag:6]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:6];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
            }
        }
        
        //上个选择按钮的tag为7
        if (lastSelectIndex == 7) {
            
            switch (tag) {
                case 1:
                    if (![self selectArrayContainBtnOfTag:4]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:4];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 3:
                    if (![self selectArrayContainBtnOfTag:5]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:5];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 9:
                    if (![self selectArrayContainBtnOfTag:8]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:8];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
            }
        }
        
        //上个选择按钮的tag为9
        if (lastSelectIndex == 9) {
            
            switch (tag) {
                case 1:
                    if (![self selectArrayContainBtnOfTag:5]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:5];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 3:
                    if (![self selectArrayContainBtnOfTag:6]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:6];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
                case 7:
                    if (![self selectArrayContainBtnOfTag:8]) {
                        
                        UIButton *button = [self getBtnFromBtnArrayWithTag:8];
                        if (button) {
                            
                            button.highlighted = YES;
                            [_selectorArr addObject:button];
                        }
                    }
                    break;
            }
        }


        //2->8  或者  8->2 或 4->6  或者  6->4
        if ((lastSelectIndex == 2 && tag == 8) || (lastSelectIndex == 2 && tag == 8)||(lastSelectIndex == 4 && tag == 6) || (lastSelectIndex == 6 && tag == 4)) {
            
            if (![self selectArrayContainBtnOfTag:5]) {
                        
                UIButton *button = [self getBtnFromBtnArrayWithTag:5];
                if (button) {
                    
                button.highlighted = YES;
                [_selectorArr addObject:button];
                }
            }
        }
    }
}

//根据给定的按钮tag,判断是否已经添加到已选择数组中
-(BOOL)selectArrayContainBtnOfTag:(NSInteger)tag{
    
    __block BOOL res;
    [self.selectorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *button = (UIButton*)obj;
        if (button.tag == tag) {
            
            res =  YES;
        }
    }];
    
    return res;
}

//根据tag返回btn
-(UIButton*)getBtnFromBtnArrayWithTag:(NSInteger)tag{
    
    __block UIButton *button = nil;
    [self.buttonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = (UIButton*)obj;
        if (btn.tag == tag) {
            button = btn;
        }
    }];
    
    return button;
}

#pragma mark 懒加载

-(NSMutableArray *)selectorArr
{
    if (!_selectorArr) {
        _selectorArr = [[NSMutableArray alloc]init];
    }
    return _selectorArr;
}


@end
