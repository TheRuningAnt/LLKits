//
//  PTTPlayAVBasic.m
//  MakeLearn-iOS
//
//  Created by 赵广亮 on 2017/8/30.
//  Copyright © 2017年 董彩丽. All rights reserved.
//

#define kTimerWidth 278*WIDTH_SCALE
#import <AVKit/AVKit.h>
#import "PTTPlayAVBasic.h"

@interface PTTPlayAVBasic()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,assign) __block BOOL couldPlay;
@property (nonatomic,strong) NSTimer *timer; //计时器
@property (nonatomic,assign) NSInteger duration;
@property (nonatomic,assign) CGFloat subLength;  //每次增加长度
@end

@implementation PTTPlayAVBasic

-(instancetype)initWithAudioUrl:(NSString*)url action:(void (^)(NSInteger duration))action{
    
    self = [super init];
    _couldPlay = NO;
    
    if (self) {
        
        //将数据保存到本地指定位置,创建保存音乐的文件夹,检测该音频文件是否下载过
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileDir = [NSString stringWithFormat:@"%@/%@",docDirPath, @"downloadAudio"];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _timer =  [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:0.01 target:self selector:@selector(timerBack) userInfo:nil repeats:YES];;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        WK(weakSelf);
        //这个操作放在后台去下载
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //创建下载路径，检测本地是否有缓存文件,有的话则不用下载
            NSString *filePath = [NSString stringWithFormat:@"%@/downloadAudio/%@", docDirPath , [url lastPathComponent]];
            if (![fileManager fileExistsAtPath:filePath isDirectory:nil]) {
                
                NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                [audioData writeToFile:filePath atomically:YES];
            }
            
            //下载完成之后  可以开始其他的下载
            _couldPlay = YES;
            
            //播放本地音乐
            NSData * audioData = [NSData dataWithContentsOfFile:filePath];
            if (audioData && audioData.length > 0) {
                
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
                
                _audioPlayer.numberOfLoops = 0;
                _audioPlayer.delegate = weakSelf;
                _duration = 0;
                _duration = ((NSInteger)(_audioPlayer.duration*100))/100;
                _subLength = kTimerWidth/_duration*1.0;
                
                if (action) {
                    action(_duration);
                }
            }
        });
    }
    
    return self;
}

-(instancetype)initWithAudioUrl:(NSString*)url{
    
    self = [super init];
    _couldPlay = NO;
    
    if (self) {
        
        //将数据保存到本地指定位置,创建保存音乐的文件夹,检测该音频文件是否下载过
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileDir = [NSString stringWithFormat:@"%@/%@",docDirPath, @"downloadAudio"];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _timer =  [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:0.01 target:self selector:@selector(timerBack) userInfo:nil repeats:YES];;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        WK(weakSelf);
        //这个操作放在后台去下载
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //创建下载路径，检测本地是否有缓存文件,有的话则不用下载
            NSString *filePath = [NSString stringWithFormat:@"%@/downloadAudio/%@", docDirPath , [url lastPathComponent]];
            if (![fileManager fileExistsAtPath:filePath isDirectory:nil]) {
                
                NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                [audioData writeToFile:filePath atomically:YES];
            }
            
            //下载完成之后  可以开始其他的下载
            _couldPlay = YES;
            
            //播放本地音乐
            NSData * audioData = [NSData dataWithContentsOfFile:filePath];
            if (audioData && audioData.length > 0) {
                
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
                
                _audioPlayer.numberOfLoops = 0;
                _audioPlayer.delegate = weakSelf;
                _duration = 0;
                _duration = ((NSInteger)(_audioPlayer.duration*100))/100;
                _subLength = kTimerWidth/_duration*1.0;
            }
        });
    }

    return self;
}

-(NSInteger)getDuration{
    
    return _duration;
}

-(void)fastPlay:(NSInteger)inerval{
    
    NSInteger time = _audioPlayer.currentTime + inerval;
    if (time <= self.duration && time >= 0) {
        
        self.audioPlayer.currentTime = time;
    }
}

-(void)backPlay:(NSInteger)inerval{
    
    NSInteger time = _audioPlayer.currentTime - inerval;
    if (time <= self.duration && time >= 0) {
        
        self.audioPlayer.currentTime = time;
    }
}

-(void)playLocalAudio:(NSString *)audio{  //播放本地音频
    
    //播放本地音乐
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:audio ofType:@"mp3"]];
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    _audioPlayer.numberOfLoops = 0;
    
    [_audioPlayer play];
}

-(void)play{
    
    if (_couldPlay) {
        
        [self.audioPlayer play];
        _playing = YES;
        
        [_timer setFireDate:[NSDate distantPast]];
    }else{
        [ShowMessageTipUtil showTipLabelWithMessage:@"音频未下载完成" spacingWithTop:kWindowHeight/4*3 stayTime:3];
    }
}

/*
 1. [myTimer setFireDate:[NSDate distantFuture]];
 然后就可以使用下面的方法再此开启这个timer了：
 
 1. //开启定时器
 2. [myTimer setFireDate:[NSDate distantPast]];
 */

-(void)pause{
    
    if (_couldPlay) {
        
        [self.audioPlayer pause];
        _playing = NO;
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)stop{
    
    if (_couldPlay) {
        
        [self.audioPlayer stop];
        _playing = NO;
        [_timer setFireDate:[NSDate distantFuture]];
        CGRect frame = _tipImageV.frame;
        _tipImageV.frame = CGRectMake(frame.origin.x, frame.origin.y,0, frame.size.height);
    }
    
    if (_playEndBlock) {
        
        _playEndBlock();
    }
}

//NSTimer 回调
-(void)timerBack{
    
    //如果有设定的回调就不管
    if (_playAnimationBack) {
        CGFloat rate = _audioPlayer.currentTime/_audioPlayer.duration;
        _playAnimationBack(rate,_audioPlayer.duration,_audioPlayer.currentTime);
        return;
    }
    
    CGRect frame = _tipImageV.frame;
    _tipImageV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + _subLength, frame.size.height);
}

#pragma mark playDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    _playing = NO;
    [_timer setFireDate:[NSDate distantFuture]];
    CGRect frame = _tipImageV.frame;
    _tipImageV.frame = CGRectMake(frame.origin.x, frame.origin.y,0, frame.size.height);
    if (_playEndBlock) {
        
        _playEndBlock();
    }
}

@end

