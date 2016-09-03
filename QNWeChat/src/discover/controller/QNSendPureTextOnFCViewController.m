//
//  QNSendPureTextOnFCViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/9/3.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNSendPureTextOnFCViewController.h"
#import "UIBarButtonItem+QNExtention.h"

@interface QNSendPureTextOnFCViewController ()

@property (weak, nonatomic) IBOutlet YYTextView *textView;

@end

@implementation QNSendPureTextOnFCViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    [self setupNavigationItems];
    [self setupTextView];
}

- (void)setupNavigationItems
{
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:@"发送" textColor:Globle_WeChat_Color target:self action:@selector(rightItemButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"取消" textColor:[UIColor whiteColor] target:self action:@selector(leftItemButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTextView
{
    [self.textView becomeFirstResponder];
//    self.textView.inputAccessoryView =
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    accessoryView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    button.frame = CGRectMake(12, 5, 40, 40);
    [button addTarget:self action:@selector(keyboardAccessoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:button];
    self.textView.inputAccessoryView = accessoryView;
}

- (void)leftItemButtonClicked:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemButtonClicked:(UIButton *)btn
{
    
}

- (void)keyboardAccessoryButtonClicked:(UIButton *)btn
{
    
}

@end
