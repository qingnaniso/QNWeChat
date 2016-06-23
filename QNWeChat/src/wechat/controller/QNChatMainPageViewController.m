//
//  QNChatMainPageViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNChatMainPageViewController.h"
#import "QNInputToolView.h"

@interface QNChatMainPageViewController ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) QNInputToolView *inputView;
@property (strong, nonatomic) NSDictionary *keyBoardDic;

@end

@implementation QNChatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.personModel.name;
    [self initKeyboardAccessoryView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)tap
{
    [self.inputView makeKeyBoardHidden];
}

- (void)tap2
{
    [self.textField becomeFirstResponder];
}

- (void)keyNotification:(NSNotification *)notification
{
    self.keyBoardDic = notification.userInfo;
    CGRect rect = [self.keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect r1 = [self.view convertRect:rect fromView:self.view.window];
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        CGRect frame = self.inputView.frame;
        frame.origin.y = r1.origin.y - frame.size.height;
        self.inputView.frame = frame;
    }];
}

- (void)initKeyboardAccessoryView
{
    self.inputView = [[QNInputToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    self.inputView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.inputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
