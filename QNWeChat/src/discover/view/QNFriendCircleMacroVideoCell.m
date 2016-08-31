//
//  QNFriendCircleMacroVideoCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/25.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleMacroVideoCell.h"
#import "QNMacroVideoContentView.h"
#import "QNVideoManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface QNFriendCircleMacroVideoCell ()

@property (strong, nonatomic) AVPlayerViewController *playerControl;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) QNVideoManager *videoManager;

@end

@implementation QNFriendCircleMacroVideoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupSubview];
    }
    
    return self;
}

- (void)setupSubview
{
    NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    
    NSURL *url = [array firstObject];
    
    self.fileURL = [url URLByAppendingPathComponent:@"myMovie.mov"];
    
    self.playerControl = [[AVPlayerViewController alloc] init];
    self.playerControl.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerControl.showsPlaybackControls = false;
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    self.playerControl.player = self.player;
    self.playerControl.player.volume = 0.0f;
    [self.playerControl.player play];
    [self.cellContentView addSubview:self.playerControl.view];
    [self.playerControl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.contentLabel.mas_bottom).offset = 5;
        make.left.equalTo(self.cellContentView);
        make.height.equalTo(@180);
        make.width.equalTo(@240);
        make.bottom.equalTo(self.cellContentView.mas_bottom);
    }];
    self.playerControl.view.userInteractionEnabled = NO;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeToFroeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
}

- (void)updateContent:(QNFriendCircleModel *)content
{
    [super updateContent:content];
    [self initPlayerView:content];
}

- (void)initPlayerView:(QNFriendCircleModel *)content
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.playerItem = [AVPlayerItem playerItemWithURL:self.fileURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self.playerControl.player replaceCurrentItemWithPlayerItem:self.playerItem];
        });
    });
}

- (void)runLoopTheMovie:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    
    [self.playerControl.player play];
}

- (void)comeToFroeground:(NSNotification *)notification
{
    [self.player play];
}

@end
