//
//  QNAudioManager.h
//  QNWeChat
//
//  Created by smartrookie on 16/7/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNAudioManager : NSObject

-(void)recodeStart:(NSString *)recoderFileName;
- (NSURL *)recodeEnd;
-(void)play:(NSURL *)url;
- (void)cancelRecoder;
- (void)showAudioWave:(BOOL)boolean;
- (int)timeIntervalForFileName:(NSString *)fileName; //aka voice chatID
- (BOOL)isPlaying;
- (void)stopPlay;
@end
