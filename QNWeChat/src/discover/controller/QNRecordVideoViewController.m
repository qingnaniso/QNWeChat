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
} movieRecordType;

#define GlobleControlColor [UIColor colorWithR:130 G:231 B:70]

@interface QNRecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureMovieFileOutput *output;
@property (strong, nonatomic) UILabel *recordButton;
@property (strong, nonatomic) UIView *processView;
@property (nonatomic) movieRecordType recordType;

@end

@implementation QNRecordVideoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    [self initLeftNavigationItem];
    [self initBackgroundView];
    [self beginAVCapture];
}

- (void)initLeftNavigationItem
{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"取消" textColor:[UIColor colorWithR:130 G:231 B:70] target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initBackgroundView
{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)beginAVCapture
{
    self.session = [[AVCaptureSession alloc] init];
    
    //configuration
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    }
    
    // add input
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                NSError *error;
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
    
    // add output
    self.output = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    [self.session startRunning];
    
    // add preview
    UIView *cameraView = [[UIView alloc] init];
    [self.view addSubview:cameraView];
    
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_topMargin).offset = 64.f;;
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kScreenWidth * 2.2 / 3));
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = cameraView.bounds;
        [cameraView.layer addSublayer:previewLayer];
        
        //addButton
        self.recordButton = [self createLabel:@"按住拍" action:@selector(recorderButtonClicked:) y:(64 + (kScreenWidth * 2.2 / 3) + 50)];
        [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(cameraView.mas_bottom).offset = 50.f;
            make.centerX.equalTo(self.view.mas_centerX);
            if (IS_IPHONE_6P) {
                make.width.and.height.equalTo(@(200));

            } else {
                make.width.and.height.equalTo(@(100));
            }
            
        }];
        
        // add Process View
        self.processView = [self createProcessView];
        [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cameraView.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(@2);
            make.width.equalTo(@(kScreenWidth));
        }];
        
    });
    self.recordType = movieRecordTypeStandBy;

}

- (UIView *)createProcessView
{
    UIView *process = [[UIView alloc] init];
    process.backgroundColor = [UIColor blackColor];
    [self.view addSubview:process];
    return process;
}

- (UILabel *)createLabel:(NSString *)title action:(SEL)action y:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = GlobleControlColor;
    label.layer.cornerRadius = IS_IPHONE_6P ? 100 : 50;
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

- (UIButton *)createBtn:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setAlpha:1];
    [btn setTitleColor:GlobleControlColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = IS_IPHONE_6P ? 100 : 50;
    btn.layer.borderColor = GlobleControlColor.CGColor;
    btn.layer.borderWidth = 1.f;
    [btn sizeToFit];
    [self.view addSubview:btn];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.1;
    [btn addGestureRecognizer:longPress];
    return btn;
}

- (void)recorderButtonClicked:(UIButton *)btn
{
    
}

- (void)longPress:(UIGestureRecognizer *)rec
{
    if (rec.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
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
    } else if (rec.state == UIGestureRecognizerStateEnded) {
        
        if (self.recordType == movieRecordTypeRecording) {
            self.recordType = movieRecordTypeRecordFinish;
            [self buttonClicked:nil];
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform transform = CGAffineTransformIdentity;
                self.recordButton.transform = CGAffineTransformScale(transform, 1.0, 1.0);
                self.recordButton.alpha = 1.;
                self.processView.backgroundColor = [UIColor blackColor];
            }];
        }
        

    }
}

- (void)resetRecorder
{
    
}

- (void)processViewRecordingAnimation
{
    if (self.recordType == movieRecordTypeRecording) {
        
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        
        [UIView animateWithDuration:8 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.processView.backgroundColor = [UIColor blackColor];
            self.recordType = movieRecordTypeRecordFinish;
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

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"%@",outputFileURL);
    self.recordType = movieRecordTypeStandBy;
    [self performSegueWithIdentifier:@"recordToAddComment" sender:outputFileURL];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"%@",fileURL);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"start");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordToAddComment"]) {
        
        QNAddCommentOnVideoViewController *vc = segue.destinationViewController;
        vc.recordURL = sender;
    }
}

@end



