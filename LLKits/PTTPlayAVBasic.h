//
//  PTTPlayAVBasic.h
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2017/8/30.
//  Copyright © 2017年 董彩丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTPlayAVBasic : NSObject

@property (nonatomic,assign) __block BOOL playing;
@property (nonatomic,strong) UIImageView *tipImageV;  //外部传来 更改frame的view
@property (nonatomic,assign) NSInteger backInterval;

@property (nonatomic,copy) void (^playEndBlock)();  //播放完成回调

@property (nonatomic,copy) void (^playAnimationBack)(CGFloat rate,NSInteger duration,CGFloat currentTime);  //播放进度回调

-(instancetype)initWithAudioUrl:(NSString*)url;

-(instancetype)initWithAudioUrl:(NSString*)url action:(void (^)(NSInteger duration))action;

-(void)playLocalAudio:(NSString *)audio; //播放本地音频

-(void)play;  //播放

-(void)pause;   //暂停

-(void)stop;    //停止

-(void)fastPlay:(NSInteger)inerval;  //快进

-(void)backPlay:(NSInteger)inerval; //快退

-(NSInteger)getDuration; //获取时播放总长

@end
