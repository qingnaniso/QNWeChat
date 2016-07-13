//
//  QNAudioManager.m
//  QNWeChat
//
//  Created by smartrookie on 16/7/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface QNAudioManager() <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recoder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary *recodeTimeDic;
@property (nonatomic) BOOL showAudioWave;
@property (nonatomic, strong) UIView *waveView;
@property (nonatomic, strong) UIImageView *waveImage;
@end

@implementation QNAudioManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.recodeTimeDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)play:(NSURL *)url
{
    self.player = nil;
    [self audioSettingForPlayer:url];
    [self setAudioSessionForPlayer];
    [self.player play];
}

-(void)stopPlay
{
    if (self.player.isPlaying) {
        [self.player stop];
    }
}

-(void)recodeStart:(NSString *)recoderFileName
{
    self.recoder = nil;
    [self audioSettingForRecorder:recoderFileName];
    [self.recoder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    self.timer.fireDate=[NSDate distantPast];
    [self.recodeTimeDic setObject:@([NSDate timeIntervalSinceReferenceDate]) forKey:recoderFileName];
    if (self.showAudioWave) {
        
        self.waveView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 75, kScreenHeight / 2 - 75, 150, 150)];
        self.waveView.backgroundColor = [UIColor blackColor];
        self.waveView.alpha = 0.5;
        self.waveView.layer.cornerRadius = 3;
        [[UIApplication sharedApplication].keyWindow addSubview:self.waveView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.waveView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigMicophone"]];
        imageView.frame = CGRectMake(20, 30, 50, 80);
        [self.waveView addSubview:imageView];
        
        self.waveImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 50, 40, 60)];
        [self.waveView addSubview:self.waveImage];

    }
}

-(NSURL *)recodeEnd
{
    [self.waveView removeFromSuperview];
    self.waveView = nil;
    
    if (self.recoder && [self.recoder isRecording]) {
        
        // calculate recoder time
        self.timer.fireDate = [NSDate distantFuture];
        NSString *fileName = [self.recoder.url lastPathComponent];
        NSNumber *startTime = [self.recodeTimeDic objectForKey:fileName];
        int timeInterval = [NSDate timeIntervalSinceReferenceDate] - startTime.intValue;
        [self.recodeTimeDic setObject:@(timeInterval + 0.5) forKey:fileName];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.recoder stop];
        });
        return self.recoder.url;
    } else {
        return nil;
    }
}

-(void)cancelRecoder
{
    if (self.recoder && [self.recoder isRecording]) {
        [self.recoder stop];
        [self.recoder deleteRecording];
    }
}
-(void)showAudioWave:(BOOL)boolean
{
    self.showAudioWave = boolean;
}

- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

-(int)timeIntervalForFileName:(NSString *)fileName
{
    NSNumber *time = [self.recodeTimeDic objectForKey:fileName];
    return time.intValue;
}
- (void)audioSettingForPlayer:(NSURL *)url
{
    NSError *erro;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&erro];
    NSLog(@"%@",erro);
    self.player.delegate = self;
    self.player.volume = 1.0;
    self.player.numberOfLoops=0;
    [self.player prepareToPlay];
}

- (void)audioSettingForRecorder:(NSString *)recoderFileName
{
    [self setAudioSessionForRecoder];
    NSError *erro;
    self.recoder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath:recoderFileName] settings:[self getAudioSetting] error:&erro];
    NSLog(@"%@",erro);
    self.recoder.delegate = self;
    self.recoder.meteringEnabled=YES;
}

#pragma mark - audio setting
/**
 *  设置音频会话
 */
-(void)setAudioSessionForRecoder{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
-(void)setAudioSessionForPlayer{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath:(NSString *)recoderFileName
{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:recoderFileName];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.recoder updateMeters];//更新测量值
    float power= [self.recoder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    NSLog(@"progress=%f",progress);
    
    if (self.waveView) {
        
        if (progress < 0.76) {
            self.waveImage.image = [UIImage imageNamed:@"voice0"];
        } else if (progress >= 0.76 && progress < 0.8) {
            self.waveImage.image = [UIImage imageNamed:@"voice1"];

        } else if (progress >= 0.8 && progress < 0.83) {
            self.waveImage.image = [UIImage imageNamed:@"voice2"];

        } else if (progress >= 0.83 && progress < 0.85) {
            self.waveImage.image = [UIImage imageNamed:@"voice3"];

        } else if (progress >= 0.85 && progress < 0.88) {
            self.waveImage.image = [UIImage imageNamed:@"voice4"];

        } else if (progress >= 0.88) {
            self.waveImage.image = [UIImage imageNamed:@"voice5"];

        }
        
    }
}


@end
