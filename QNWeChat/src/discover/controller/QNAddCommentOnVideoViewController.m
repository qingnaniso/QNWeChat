//
//  QNAddCommentOnVideoViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/17.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNAddCommentOnVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIBarButtonItem+QNExtention.h"

@interface QNAddCommentOnVideoViewController ()

@property (strong, nonatomic) AVPlayerViewController *playerControl;
@property (strong, nonatomic) AVPlayer *player;

@end
@implementation QNAddCommentOnVideoViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initLeftNavigationItem];
    self.playerControl = [[AVPlayerViewController alloc] init];
    self.player = [AVPlayer playerWithURL:self.recordURL];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    self.playerControl.player = self.player;
    self.playerControl.player.volume = 0.0f;
    self.playerControl.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerControl.showsPlaybackControls = false;
    [self.playerControl.player play];
    self.playerControl.view.frame = CGRectMake(80, 100, 200, 160);
    [self.view addSubview:self.playerControl.view];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeToFroeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)initLeftNavigationItem
{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"取消" textColor:[UIColor colorWithR:130 G:231 B:70] target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemClicked:(id)sm
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)runLoopTheMovie:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    
    [self.playerControl.player play];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)comeToFroeground:(NSNotification *)notification
{
    [self.player play];
}

@end
