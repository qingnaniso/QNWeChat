//
//  QNVideoManager.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNVideoManager.h"

@interface QNVideoManager ()
@property (strong, nonatomic) AVAssetReader *reader;
@end

@implementation QNVideoManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.reader = [[AVAssetReader alloc] initWithAsset:[[AVAsset alloc] init] error:nil];
    }
    return self;
}

-(void)updateAsset:(AVAsset *)asset
{
    if (!asset) {
        return;
    }
    NSArray *trackouts = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [trackouts firstObject];
//    m_pixelFormatType=kCVPixelFormatType_32BGRA
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput* videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                                   initWithTrack:track outputSettings:options];
    [self.reader addOutput:videoReaderOutput];
    [self.reader startReading];
    
    while (self.reader.status == AVAssetReaderStatusReading  && track.nominalFrameRate > 0 ) {
        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
        [self.delegate videoManager:self newVideoFrameReady:videoBuffer];
        CFRelease(videoBuffer);
        [NSThread sleepForTimeInterval:0.1];
    }
    [self.delegate videoDecoderFinish];
}

@end
