//
//  QNRecordVideoViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/15.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNRecordVideoViewController.h"
#import "UIBarButtonItem+QNExtention.h"
#import <AVFoundation/AVFoundation.h>
#import "QNAddCommentOnVideoViewController.h"

typedef enum : NSUInteger {
    movieRecordTypeStandBy,
    movieRecordTypeRecording,
    movieRecordTypeRecordFinish,
    movieRecordTypeRecordingDoubleScale,
    movieRecordTypeRecordingNormalScale,
    movieRecordTypeRecordingWillCancel,
    movieRecordTypeRecordingDidCanceled,
} movieRecordType;

#define GlobleControlColor [UIColor colorWithR:130 G:231 B:70]

@interface QNRecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureMovieFileOutput *output;
@property (strong, nonatomic) UILabel *recordButton;
@property (strong, nonatomic) UIView *processView;
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) movieRecordType recordType;
@property (nonatomic, strong) UILabel *cancelWarnLabel;

@end

@implementation QNRecordVideoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

#pragma mark - int views

- (void)initView
{
    [self initLeftNavigationItem];
    [self initBackgroundView];
    [self configAVCapture];
}

- (void)initLeftNavigationItem
{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"取消" textColor:GlobleControlColor target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initBackgroundView
{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)configAVCapture
{
    self.session = [[AVCaptureSession alloc] init];
    
    //configuration
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    [self.session beginConfiguration];
    
    // add input
    [self addInput];
    
    // add output
    [self addOutPut];
    
    // add preview
    self.cameraView = [self createCameraView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self addPreviewLayer];
        //addButton and ProcessView at right postion
        [self addRecordButtonAndProcessViewBelowCameraViewBottom:self.cameraView];
        
        [self.session commitConfiguration];
        [self.session startRunning];
    });
    self.recordType = movieRecordTypeStandBy;
}

- (void)addInput
{
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                
                
                NSError *error;
                
                if ( [device lockForConfiguration:&error] ) {
                    device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                    [device unlockForConfiguration];
                }
                
                AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                if (error) {
                    NSLog(@"capture device input error:%@",error);
                } else {
                    if ([self.session canAddInput:inputVideo]) {
                        [self.session addInput:inputVideo];
                    } else {
                        NSLog(@"can't add session input%@",device);
                    }
                }
            }
        } else if ([device hasMediaType:AVMediaTypeAudio]) {
            NSError *error;
            AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                NSLog(@"capture device input error:%@",error);
            } else {
                if ([self.session canAddInput:inputAudio]) {
                    [self.session addInput:inputAudio];
                } else {
                    NSLog(@"can't add session input%@",device);
                }
            }
        }
    }
}

- (void)addPreviewLayer
{
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:self.previewLayer];
}

- (void)addOutPut
{
    self.output = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
}

- (UIView *)createCameraView
{
    UIView *cameraView = [[UIView alloc] init];
    [self.view addSubview:cameraView];
    
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_topMargin).offset = 64.f;;
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kScreenWidth * 2.2 / 3));
        
    }];
    
    cameraView.userInteractionEnabled = YES;
    cameraView.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [cameraView addGestureRecognizer:singleTap];
    [cameraView addGestureRecognizer:doubleTap];
    
    return cameraView;
}

- (UIView *)createProcessView
{
    UIView *process = [[UIView alloc] init];
    process.backgroundColor = [UIColor blackColor];
    [self.view addSubview:process];
    return process;
}

- (void)addRecordButtonAndProcessViewBelowCameraViewBottom:(UIView *)cameraView
{
    //add record button
    self.recordButton = [self createLabel:@"按住拍" action:nil y:(64 + (kScreenWidth * 2.2 / 3) + 50)];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cameraView.mas_bottom).offset = 50.f;
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.and.height.equalTo(@(200));
    }];
    
    // add Process View
    self.processView = [self createProcessView];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@2);
        make.width.equalTo(@(kScreenWidth));
    }];
}

- (UILabel *)createLabel:(NSString *)title action:(SEL)action y:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = GlobleControlColor;
    label.layer.cornerRadius = 100;
    label.layer.borderColor = [UIColor colorWithR:130 G:231 B:70].CGColor;
    label.layer.borderWidth = 1.f;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
    label.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.01;
    [label addGestureRecognizer:longPress];
    return label;
}

- (void)showCancelRecordWarning
{
    self.recordType = movieRecordTypeRecordingWillCancel;
    if (!self.cancelWarnLabel) {
        self.cancelWarnLabel = [[UILabel alloc] init];
        self.cancelWarnLabel.text = @"松开取消";
        self.cancelWarnLabel.textColor = [UIColor whiteColor];
        self.cancelWarnLabel.backgroundColor = [UIColor redColor];
        [self.cameraView addSubview:self.cancelWarnLabel];
        [self.cancelWarnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cameraView.mas_bottom).offset = -5;
            make.centerX.equalTo(self.cameraView.mas_centerX);
        }];
    }

}

- (void)hideCancelRecordWaring
{
    self.recordType = movieRecordTypeRecording;
    if (self.cancelWarnLabel) {
        [self.cancelWarnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.cameraView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.cancelWarnLabel = nil;
        }];
    }
}

#pragma mark - actions

- (void)leftItemClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)longPress:(UIGestureRecognizer *)rec
{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
        self.recordType = movieRecordTypeRecording;
        
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            self.recordButton.transform = CGAffineTransformScale(transform, 1.5, 1.5);
            self.recordButton.alpha = 0.;
            self.processView.backgroundColor = GlobleControlColor;
        }];
        [self beginRecord:nil];
        
    } else if (rec.state == UIGestureRecognizerStateFailed) {
        NSLog(@"failed");
    } else if (rec.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [rec locationInView:self.view];
        
        if (!CGRectContainsPoint(self.recordButton.frame, point)) {
    
            [self showCancelRecordWarning];
        } else {
            [self hideCancelRecordWaring];
        }
    }else if (rec.state == UIGestureRecognizerStateEnded) {
        
        if (self.recordType == movieRecordTypeRecording) {
            self.recordType = movieRecordTypeRecordFinish;
            [self buttonClicked:nil];
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform transform = CGAffineTransformIdentity;
                self.recordButton.transform = CGAffineTransformScale(transform, 1.0, 1.0);
                self.recordButton.alpha = 1.;
                self.processView.backgroundColor = [UIColor blackColor];
            }];
        } else if (self.recordType == movieRecordTypeRecordingWillCancel) {
            [self resetAVCapture];
        }
    }
}

- (void)resetAVCapture
{
    [self hideCancelRecordWaring];
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.recordButton.transform = CGAffineTransformScale(transform, 1.0, 1.0);
        self.recordButton.alpha = 1.;
        self.processView.backgroundColor = [UIColor blackColor];
    }];
    self.recordType = movieRecordTypeStandBy;
}

- (void)processViewRecordingAnimation
{
    if (self.recordType == movieRecordTypeRecording) {
        
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        
        [UIView animateWithDuration:5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.processView.backgroundColor = [UIColor blackColor];
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform transform = CGAffineTransformIdentity;
                self.recordButton.transform = CGAffineTransformScale(transform, 1.0, 1.0);
                self.recordButton.alpha = 1.;
                self.processView.backgroundColor = [UIColor blackColor];
            }];
            if (self.recordType == movieRecordTypeRecording) {
                self.recordType = movieRecordTypeRecordFinish;
                [self buttonClicked:nil];
            }
        }];
    }
}

- (IBAction)beginRecord:(id)sender {
    
    NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    
    NSURL *url = [array firstObject];
    
    NSURL *filePath = [url URLByAppendingPathComponent:@"myMovie.mov"];
    
    [self.output startRecordingToOutputFileURL:filePath recordingDelegate:self];
    
    [self processViewRecordingAnimation];

}

- (IBAction)buttonClicked:(id)sender {

    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if ([self.output isRecording]) {
        [self.output stopRecording];
    }
}

- (void)singleTap:(UIGestureRecognizer *)ges
{
//    NSLog(@"state %@",@(ges.state));
    NSLog(@"single tap");
    
    CGPoint point = [ges locationInView:self.cameraView];
    
    CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];

    [self setFocusCursorAnimationWithPoint:point];
    
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                NSError *error;
                if ( [device lockForConfiguration:&error] ) {
                    
                    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                    }
                    
                    if ([device isFocusPointOfInterestSupported]) {
                        device.focusPointOfInterest = cameraPoint;
                    }
                    
                    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
                    }
                    
                    if ([device isExposurePointOfInterestSupported]) {
                        device.exposurePointOfInterest = cameraPoint;
                    }
                    
                    [device unlockForConfiguration];
                }
            }
        }
    }
}

- (void)doubleTap:(UIGestureRecognizer *)ges
{
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                NSError *error;
                if ( [device lockForConfiguration:&error] ) {
                    
                    if (self.recordType == movieRecordTypeRecordingDoubleScale) {
                        [device rampToVideoZoomFactor:1.f withRate:2];
                        self.recordType = movieRecordTypeRecordingNormalScale;

                    } else {
                        [device rampToVideoZoomFactor:2.f withRate:2];
                        self.recordType = movieRecordTypeRecordingDoubleScale;
                    }
                    
                    [self setFocusCursorAnimationWithPoint:self.previewLayer.center];
                    [device unlockForConfiguration];
                }
            }
        }
    }
}

- (void)setFocusCursorAnimationWithPoint:(CGPoint)point
{
    UIView *forcusCursorView = [[UIView alloc] init];
    forcusCursorView.backgroundColor = [UIColor clearColor];
    forcusCursorView.layer.borderColor = GlobleControlColor.CGColor;
    forcusCursorView.layer.borderWidth = 1;
    forcusCursorView.bounds = CGRectMake(0, 0, 70, 70);
    forcusCursorView.center = point;
    [self.cameraView addSubview:forcusCursorView];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        forcusCursorView.bounds = CGRectMake(0, 0, 50, 50);
        
    } completion:^(BOOL finished) {
        [forcusCursorView removeFromSuperview];
    }];
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
       return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - AVCaptureFileOutput Dlegate

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"%@",outputFileURL);
    self.recordType = movieRecordTypeStandBy;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"recordToAddComment" sender:outputFileURL];
    });
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"%@",fileURL);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"start");
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordToAddComment"]) {
        
        QNAddCommentOnVideoViewController *vc = segue.destinationViewController;
        vc.recordURL = sender;
    }
}

@end



