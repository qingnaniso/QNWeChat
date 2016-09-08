//
//  QNFriendsCirlcleViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendsCirlcleViewController.h"
#import "UIBarButtonItem+QNExtention.h"
#import "ACHeadImageChooseOptionView.h"
#import "QNFriendCircleHeaderView.h"
#import "QNFriendCircleTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QNFriendCircleMacroVideoCell.h"
#import "QNFriendCirclePureTextCell.h"
#import "QNFriendCircleModel.h"
#import "QNInputToolView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface QNFriendsCirlcleViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource, QNFriendCircleTableViewCellDelegate,QNInputToolViewDelegate>

@property (nonatomic, strong) NSArray *sendFriendsCirlceMediaTypeDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) QNInputToolView *inputView;
@property (strong, nonatomic) NSDictionary *keyBoardDic;
@property (assign, nonatomic) BOOL keyboardShow;
@property (assign, nonatomic) CGRect keyboardRect;
@property (weak, nonatomic) UIView *coverView;
@property (weak, nonatomic) QNFriendCircleTableViewCell *currentEditCell;
@property (assign, nonatomic) CGPoint oldContentOffSet;

@end

@implementation QNFriendsCirlcleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupView];
}

- (void)initData
{
    self.sendFriendsCirlceMediaTypeDataSource = @[@"小视频",@"拍照",@"从手机相册选择"];
    self.dataSource = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getFriendCircleData]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceChanged) name:QNFriendCirlceDataSourceChanged object:nil];
}

- (void)setupView
{
    [self initNavigationRightItem];
    [self initKeyboardAccessoryView];
    [self setupTableView];
}

- (void)initNavigationRightItem
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"barbuttonicon_Camera" highImage:nil target:self action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIView *view = item.customView;

    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sendTextGesture:)];
    [view addGestureRecognizer:gesture];
}

- (void)initKeyboardAccessoryView
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputView = [[QNInputToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    [self.view addSubview:self.inputView];
    [self.inputView simpleMode];
    self.inputView.delegate = self;
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

        if (self.keyboardShow) {
            frame.origin.y = r1.origin.y;
            self.inputView.frame = frame;
        } else {
            frame.origin.y = r1.origin.y - frame.size.height;
            self.inputView.frame = frame;
            self.tableView.contentOffset = CGPointMake(0, (self.currentEditCell.bottom - (r1.origin.y - frame.size.height)));
        }
        if (!self.coverView) {
            __block UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.origin.y)];
            self.coverView = coverView;
            [self.view addSubview:coverView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [self.inputView makeKeyBoardHidden];
                 [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                     self.tableView.contentOffset = self.oldContentOffSet;
                 }];
                [coverView removeFromSuperview];
                coverView = nil;
            }];
            [coverView addGestureRecognizer:tap];
        }
    }];
    self.keyboardShow = !self.keyboardShow;
}

- (void)sendTextGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"friendsCirlcleToSendText" sender:nil];
    }
}

- (void)setupTableView
{
    [self.tableView registerClass:[QNFriendCircleMacroVideoCell class] forCellReuseIdentifier:@"QNFriendCircleMacroVideoCell"];
    [self.tableView registerClass:[QNFriendCirclePureTextCell class] forCellReuseIdentifier:@"QNFriendCirclePureTextCell"];

    self.tableView.tableHeaderView = [self createHeaderView:nil];
    self.tableView.contentInset = UIEdgeInsetsMake(-80, 0, 0, 0);
    [self.tableView reloadData];
}

- (QNFriendCircleHeaderView *)createHeaderView:(NSDictionary *)infoDic
{
    QNFriendCircleHeaderView *header = [[QNFriendCircleHeaderView alloc] initWithDic:nil];
    header.frame = CGRectMake(0, 0, kScreenWidth, 400);
    return header;
}

- (void)dataSourceChanged
{
    self.dataSource = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getFriendCircleData]];
    [self.tableView reloadData];
}

#pragma mark - InputView Delegate

- (void)inputToolView:(QNInputToolView *)inputView didSendMessage:(NSString *)message
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.currentEditCell];
    QNFriendCircleModel *model = self.dataSource[indexPath.row];
    [model addCommentToModel:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    });
    [self.inputView makeKeyBoardHidden];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}

#pragma mark - TableView Cell Delegate

-(void)deleteData:(QNFriendCircleModel *)model cell:(QNFriendCircleTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    [[QNDataSource shareDataSource] removeFriendCircleData:model completionBlock:nil];
    if ([self.dataSource containsObject:model]) {
        [self.dataSource removeObject:model];
    } else {
        NSLog(@"datasource do not contains model");
    }
    [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationRight];
}

-(void)showLove:(QNFriendCircleModel *)model cell:(QNFriendCircleTableViewCell *)cell
{
    [model LoveThisModel];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

-(void)comment:(QNFriendCircleModel *)model cell:(QNFriendCircleTableViewCell *)cell
{
    self.oldContentOffSet = self.tableView.contentOffset;
    self.currentEditCell = cell;
    [self.inputView showKeyboard];
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNFriendCircleTableViewCell *cell = [self cellForModelIndex:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateContent:self.dataSource[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self identifierForCellAtIndexPath:indexPath];
    
    if (identifier) {
        return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(QNFriendCircleTableViewCell * cell) {
            [cell updateContent:self.dataSource[indexPath.row]];
        }];
    } else {
        return 0;
    }
}

- (QNFriendCircleTableViewCell *)cellForModelIndex:(NSIndexPath *)indexPath
{
    QNFriendCircleTableViewCell *cell;
    QNFriendCircleModel *model = self.dataSource[indexPath.row];
    if (model.modelType == modelTypeText) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"QNFriendCirclePureTextCell" forIndexPath:indexPath];
    } else if (model.modelType == modelTypeMacroVideo) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"QNFriendCircleMacroVideoCell" forIndexPath:indexPath];
    }
    cell.delegate = self;
    return cell;
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pureTextIdentifier = @"QNFriendCirclePureTextCell";
    static NSString *macroVideoIdentifier = @"QNFriendCircleMacroVideoCell";
    QNFriendCircleModel *model = self.dataSource[indexPath.row];
    if (model.modelType == modelTypeText) {
        return pureTextIdentifier;
    } else if (model.modelType == modelTypeMacroVideo) {
        return macroVideoIdentifier;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)rightBarButtonItemClicked:(UIButton *)item
{
    ACHeadImageChooseOptionView *optionView = [[ACHeadImageChooseOptionView alloc] initWithFrame:self.view.frame];
    optionView.dataSource = self.sendFriendsCirlceMediaTypeDataSource;
    [optionView whenTapped:^(ACChooseHeadImageType type) {
        
        NSString *chooseType = self.sendFriendsCirlceMediaTypeDataSource[type];
        
        if ([chooseType isEqualToString:@"小视频"]) {
            
            [self performSegueWithIdentifier:@"friendCircleModelToRecordVideo" sender:nil];
            
        } else if ([chooseType isEqualToString:@"拍照"]) {
            
            BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            
            if (isCameraSupport) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                [[imagePicker navigationBar] setTintColor:[UIColor whiteColor]];
                [[imagePicker navigationBar] setBarTintColor:[UIColor blackColor]];
                [[imagePicker navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        } else if ([chooseType isEqualToString:@"从手机相册选择"]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [[imagePicker navigationBar] setTintColor:[UIColor whiteColor]];
            [[imagePicker navigationBar] setBarTintColor:[UIColor blackColor]];
            [[imagePicker navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    [optionView show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
