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
#import "QNAudioManager.h"
#import "GCDAsyncSocket.h"

@interface QNChatMainPageViewController () <UITableViewDelegate, UITableViewDataSource, QNInputToolViewDelegate,GCDAsyncSocketDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) QNInputToolView *inputView;
@property (strong, nonatomic) NSDictionary *keyBoardDic;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatDataSource;
@property (nonatomic) CGPoint tableViewContentOffSet;
@property (nonatomic, strong) NSMutableDictionary *cellHeightCacheDic;
@property (nonatomic) BOOL keyboardShow;
@property (nonatomic) CGRect keyboardRect;
@property (nonatomic, strong) QNAudioManager *audioManager;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation QNChatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTableView];
    [self initKeyboardAccessoryView];
    self.audioManager = [[QNAudioManager alloc] init];
    [self.audioManager showAudioWave:YES];
    self.title = self.personModel.name;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.audioManager stopPlay];
    [self saveChatRecord];
    [super viewWillDisappear:animated];
}

- (void)initData
{
    self.cellHeightCacheDic = [NSMutableDictionary dictionary];
    self.chatDataSource = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser:self.personModel.userID]];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    [self.socket connectToHost:@"192.168.1.100" onPort:12345 error:&error];
    if (error) {
        NSLog(@"%@",error);
    } else {
        [self.socket writeData:[[NSString stringWithFormat:@"iam:%@",self.personModel.name] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:200];
    }
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 50 - 64-5) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"QNChatContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatContentCellIdentifier"];
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delaysContentTouches = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (self.chatDataSource.count > 1) {
        [self.tableView scrollToRow:(self.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
    self.keyboardRect = r1;
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        CGRect frame = self.inputView.frame;
        frame.origin.y = r1.origin.y - frame.size.height;
        self.inputView.frame = frame;
    }];
    
    if (self.keyboardShow) {
        
        [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            CGRect tableViewRect = self.tableView.frame;
            tableViewRect.size.height = kScreenHeight - 50 - 64 - 5;
            self.tableView.frame = tableViewRect;
        }];
        
    } else {
        
        [self scrollTableViewWhenChatting:NO];
    }
    self.keyboardShow = !self.keyboardShow;
}

- (void)initKeyboardAccessoryView
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputView = [[QNInputToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    [self.view addSubview:self.inputView];
    self.inputView.delegate = self;
}

- (void)scrollTableViewWhenChatting:(BOOL)shouldScrollForKeyboardClose
{
    UITableViewCell *cell = self.tableView.visibleCells.lastObject;;
    CGRect cellRect = [cell convertRect:cell.contentView.frame toViewOrWindow:self.view];
    CGFloat keyboardCutCellY = self.keyboardRect.origin.y - (cellRect.origin.y + cellRect.size.height);
    
    if (keyboardCutCellY < 0) {
        
        [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            CGRect tableViewRect = self.tableView.frame;
            tableViewRect.size.height = kScreenHeight - 50 - 64 - self.keyboardRect.size.height- 5;
            self.tableView.frame = tableViewRect;
        } completion:^(BOOL finished) {
            if (self.chatDataSource.count > 0) {
                [self.tableView scrollToRow:(self.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
    } else {
        if (shouldScrollForKeyboardClose) {
            [self.tableView scrollToRow:(self.chatDataSource.count - 1) inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNChatModel *model = self.chatDataSource[indexPath.row];
    if (model.chatType == QNChatModelVoice) {
        [self.audioManager play:[NSURL URLWithString:model.voiceURL]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    return MAX(cellHeight, 64);
}

#pragma mark InputView Delegate

-(void)inputToolView:(QNInputToolView *)inputView didSendMessage:(NSString *)message
{
    QNChatModel *model = [[QNChatModel alloc] init];
    model.chatType = QNChatModelWord;
    model.chatContent = message;
    model.chatFromMe = YES;
    model.vatarURL = self.personModel.vatarURL;
    model.chatID = [message md2String];
    model.otherPerson = @[self.personModel];
    model.chatDate = [NSDate date];
    [self.chatDataSource addObject:model];
    
    [self.tableView insertRow:(self.chatDataSource.count - 1) inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
    [self scrollTableViewWhenChatting:YES];
    
    [self.socket writeData:[[NSString stringWithFormat:@"msg:%@",message] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:201];
}

-(void)inputToolViewDidSendVoice:(QNInputToolView *)inputView
{
    QNChatModel *model = [[QNChatModel alloc] init];
    model.chatType = QNChatModelVoice;
    model.chatFromMe = YES;
    model.vatarURL = self.personModel.vatarURL;
    model.chatID = [[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] md2String];
    model.otherPerson = @[self.personModel];
    [self.chatDataSource addObject:model];
    [self.audioManager recodeStart:model.chatID];
}

-(void)inputToolViewDidEndSendVoice:(QNInputToolView *)inputView
{
    NSURL *url = [self.audioManager recodeEnd];
    if (url) {
        NSString *chatID = [url lastPathComponent];
        QNChatModel *model = [self getModelFromDataSourceByChatID:chatID];
        model.voiceURL = url.absoluteString;
        model.voiceDuring = [self.audioManager timeIntervalForFileName:chatID];
        model.chatDate = [NSDate date];
        model.chatContent = @"[语音]";
        [self.tableView insertRow:(self.chatDataSource.count - 1) inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
        [self scrollTableViewWhenChatting:YES];
    }
}

-(void)inputToolView:(QNInputToolView *)inputView didSendPicture:(NSString *)message
{

}

-(void)inputToolViewDelegateFuction
{
    [self.audioManager play:nil];
}

#pragma mark - GCDAsnySocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"connected success! host is %@",host);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"socket error %@",err);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [self.socket readDataWithTimeout:-1 tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
    NSLog(@"read data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

#pragma mark - tool function

- (void)saveChatRecord
{
    NSArray *oldArray = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser:self.personModel.userID]];
    
    if (self.chatDataSource.count == oldArray.count) {
        return;
    }
    [[QNDataSource shareDataSource] addARecordToUser:self.personModel.userID];
    [[QNDataSource shareDataSource] addWechatMainPageDataSourceByUser:self.personModel.userID objects:self.chatDataSource];
}

- (id)getModelFromDataSourceByChatID:(NSString *)chatID
{
    __block id model;
    [self.chatDataSource enumerateObjectsUsingBlock:^(QNChatModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.chatID isEqualToString:chatID]) {
            model = obj;
        }
    }];
    return model;
}

#pragma mark - audio delegate


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
