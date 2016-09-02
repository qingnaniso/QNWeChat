//
//  QNVideoManager.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 *
 * a decorder for macro video.
 *
 */
@class QNVideoManager;
@protocol QNVideoManagerDelegate <NSObject>
@required
- (void)videoManager:(QNVideoManager *)manager newVideoFrameReady:(CMSampleBufferRef)buffer;
- (void)videoDecoderFinish;

@end

@interface QNVideoManager : NSObject

@property (weak, nonatomic) id<QNVideoManagerDelegate> delegate;
- (void)updateAsset:(AVURLAsset *)asset;

@end
