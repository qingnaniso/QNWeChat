//
//  QNChatMainPageViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNChatMainPageViewController.h"
#import "QNInputToolView.h"
#import "QNChatModel.h"
#import "QNChatContentTableViewCell.h"

@interface QNChatMainPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) QNInputToolView *inputView;
@property (strong, nonatomic) NSDictionary *keyBoardDic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatDataSource;
@property (nonatomic) CGPoint tableViewContentOffSet;
@property (nonatomic, strong) NSMutableDictionary *cellHeightCacheDic;
@property (nonatomic) BOOL keyboardShow;

@end

@implementation QNChatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initKeyboardAccessoryView];
    [self initTableView];
    self.title = self.personModel.name;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)initData
{
    self.chatDataSource = [NSMutableArray array];
    self.cellHeightCacheDic = [NSMutableDictionary dictionary];
}

- (void)initTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"QNChatContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatContentCellIdentifier"];
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
}

- (void)tap
{
    [self.inputView makeKeyBoardHidden];
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
        NSLog(@"x=%fy=%f",r1.origin.x,r1.origin.y);
    }];
    
    if (self.keyboardShow) {
        
    } else {
        
        if (self.chatDataSource.count > 0) {
            
            NSIndexPath *idx = [NSIndexPath indexPathForRow:(self.chatDataSource.count - 1) inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:idx];
            CGRect cellRect = [cell convertRect:cell.contentView.frame toViewOrWindow:self.view];
            CGFloat keyboardCutCellY = r1.origin.y - (cellRect.origin.y + cellRect.size.height);
            
            if (keyboardCutCellY < 0) {
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.bottom.equalTo(self.view).offset = r1.origin.y;
                }];
            }
        }
    }

    self.keyboardShow = !self.keyboardShow;
}

- (void)initKeyboardAccessoryView
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputView = [[QNInputToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    [self.view addSubview:self.inputView];
    WS(weakSelf);
    self.inputView.QNInputToolViewSendMessageBlock = ^(NSString *textContent){
        
        QNChatModel *model = [[QNChatModel alloc] init];
        model.chatType = QNChatModelWord;
        model.chatContent = textContent;
        model.chatFromMe = YES;
        model.vatarURL = weakSelf.personModel.vatarURL;
        model.chatID = [textContent md2String];
        [weakSelf.chatDataSource addObject:model];
        
        [weakSelf.tableView insertRow:(weakSelf.chatDataSource.count - 1) inSection:0 withRowAnimation:UITableViewRowAnimationRight];
        [weakSelf.tableView scrollToRow:(weakSelf.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    };
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNChatContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatContentCellIdentifier"];
    
    QNChatModel *model = self.chatDataSource[indexPath.row];
    
    [cell updateContent:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNChatModel *model = self.chatDataSource[indexPath.row];
    
    NSNumber *height = [self.cellHeightCacheDic objectForKey:model.chatID];
    
    CGFloat cellHeight;
    
    if (!height) {
        
        cellHeight = [QNChatContentTableViewCell cellHeightForContent:model];
        
        [self.cellHeightCacheDic setObject:[NSNumber numberWithFloat:cellHeight] forKey:model.chatID];
    } else {
        cellHeight = height.floatValue;
    }
    return cellHeight;
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
