//
//  QNChatMainPageViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNChatMainPageViewController.h"
#import "QNInputToolView.h"
#import "QNChatModel.h"
#import "QNChatContentTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface QNChatMainPageViewController () <UITableViewDelegate, UITableViewDataSource, QNInputToolViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) QNInputToolView *inputView;
@property (strong, nonatomic) NSDictionary *keyBoardDic;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatDataSource;
@property (nonatomic) CGPoint tableViewContentOffSet;
@property (nonatomic, strong) NSMutableDictionary *cellHeightCacheDic;
@property (nonatomic) BOOL keyboardShow;
@property (nonatomic) CGRect keyboardRect;

@property (nonatomic, strong) AVAudioRecorder *recoder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QNChatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self audioSetting];
    [self initTableView];
    [self initKeyboardAccessoryView];
    self.title = self.personModel.name;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)initData
{
    self.chatDataSource = [NSMutableArray array];
    self.cellHeightCacheDic = [NSMutableDictionary dictionary];
}

- (void)audioSetting
{
    NSError *erro;
    self.recoder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath] settings:[self getAudioSetting] error:&erro];
    NSLog(@"%@",erro);
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getSavePath] error:&erro];
    NSLog(@"%@",erro);
    self.recoder.delegate = self;
    self.player.delegate = self;
    self.player.volume = 1.0;
    self.recoder.meteringEnabled=YES;
    self.player.numberOfLoops=0;
    [self.player prepareToPlay];

}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 50 - 64-5) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"QNChatContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatContentCellIdentifier"];
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)tap
{
    [self.inputView makeKeyBoardHidden];
}

- (void)keyNotification:(NSNotification *)notification
{
    self.keyBoardDic = notification.userInfo;
    CGRect rect = [self.keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect r1 = [self.view convertRect:rect fromView:self.view.window];
    self.keyboardRect = r1;
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        CGRect frame = self.inputView.frame;
        frame.origin.y = r1.origin.y - frame.size.height;
        self.inputView.frame = frame;
    }];
    
    if (self.keyboardShow) {
        
        [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            CGRect tableViewRect = self.tableView.frame;
            tableViewRect.size.height = kScreenHeight - 50 - 64 - 5;
            self.tableView.frame = tableViewRect;
        }];
        
    } else {
        
        [self scrollTableViewWhenChatting:NO];

    }
 
    self.keyboardShow = !self.keyboardShow;
}

- (void)initKeyboardAccessoryView
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputView = [[QNInputToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    [self.view addSubview:self.inputView];
    self.inputView.delegate = self;
}

- (void)scrollTableViewWhenChatting:(BOOL)shouldScrollForKeyboardClose
{
    UITableViewCell *cell = self.tableView.visibleCells.lastObject;;
    CGRect cellRect = [cell convertRect:cell.contentView.frame toViewOrWindow:self.view];
    CGFloat keyboardCutCellY = self.keyboardRect.origin.y - (cellRect.origin.y + cellRect.size.height);
    
    if (keyboardCutCellY < 0) {
        
        [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            CGRect tableViewRect = self.tableView.frame;
            tableViewRect.size.height = kScreenHeight - 50 - 64 - self.keyboardRect.size.height- 5;
            self.tableView.frame = tableViewRect;
        } completion:^(BOOL finished) {
            if (self.chatDataSource.count > 0) {
                [self.tableView scrollToRow:(self.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
    } else {
        if (shouldScrollForKeyboardClose) {
            [self.tableView scrollToRow:(self.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNChatContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatContentCellIdentifier"];
    
    QNChatModel *model = self.chatDataSource[indexPath.row];
    
    [cell updateContent:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNChatModel *model = self.chatDataSource[indexPath.row];
    
    NSNumber *height = [self.cellHeightCacheDic objectForKey:model.chatID];
    
    CGFloat cellHeight;
    
    if (!height) {
        
        cellHeight = [QNChatContentTableViewCell cellHeightForContent:model];
        
        [self.cellHeightCacheDic setObject:[NSNumber numberWithFloat:cellHeight] forKey:model.chatID];
    } else {
        cellHeight = height.floatValue;
    }
    return MAX(cellHeight, 64);
}

#pragma mark InputView Delegate

-(void)inputToolView:(QNInputToolView *)inputView didSendMessage:(NSString *)message
{
    QNChatModel *model = [[QNChatModel alloc] init];
    model.chatType = QNChatModelWord;
    model.chatContent = message;
    model.chatFromMe = YES;
    model.vatarURL = self.personModel.vatarURL;
    model.chatID = [message md2String];
    [self.chatDataSource addObject:model];
    
    [self.tableView insertRow:(self.chatDataSource.count - 1) inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
    [self scrollTableViewWhenChatting:YES];
}

-(void)inputToolViewDidSendVoice:(QNInputToolView *)inputView
{
    if (![self.recoder isRecording]) {
        [self.recoder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

-(void)inputToolViewDidEndSendVoice:(QNInputToolView *)inputView
{
    [self setAudioSessionForRecoder];
    [self.recoder stop];
    self.timer.fireDate=[NSDate distantFuture];
}

-(void)inputToolView:(QNInputToolView *)inputView didSendPicture:(NSString *)message
{
    
}

-(void)inputToolViewDelegateFuction
{
    if (![self.player isPlaying]) {
        [self setAudioSessionForPlayer];
        [self.player play];
    }
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
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:@"qnwechataudioRecoderFile"];
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
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
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
}

#pragma mark - audio delegate


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
