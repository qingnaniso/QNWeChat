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

@interface QNRecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureMovieFileOutput *output;

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
        UIButton *recordButton = [self createBtn:@"按住拍" action:@selector(recorderButtonClicked:) y:(64 + (kScreenWidth * 2.2 / 3) + 50)];
        [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(cameraView.mas_bottom).offset = 50.f;
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
    });
    

    
}

- (UIButton *)createBtn:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setAlpha:1];
    [btn setTitleColor:[UIColor colorWithR:130 G:231 B:70] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self.view addSubview:btn];
    return btn;
}

- (void)recorderButtonClicked:(UIButton *)btn
{
}

- (IBAction)beginRecord:(id)sender {
    
    NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    
    NSURL *url = [array firstObject];
    
    NSURL *filePath = [url URLByAppendingPathComponent:@"myMovie.mov"];
    
    [self.output startRecordingToOutputFileURL:filePath recordingDelegate:self];

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



