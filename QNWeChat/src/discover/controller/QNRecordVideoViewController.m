//
//  QNRecordVideoViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/15.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNRecordVideoViewController.h"
#import "UIBarButtonItem+QNExtention.h"

@implementation QNRecordVideoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"取消" textColor:[UIColor colorWithR:130 G:231 B:70] target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
