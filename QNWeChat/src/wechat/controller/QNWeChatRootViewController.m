//
//  QNWeChatRootViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNWeChatRootViewController.h"
#import "QNWeChatTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QNChatMainPageViewController.h"

@interface QNWeChatRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation QNWeChatRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRecordUpdate) name:@"shouldReloadDataForNewChatRecord" object:nil];
}

- (void)loadData
{
    self.dataSource = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getCurrentChattingForAllUsers]];
}

- (void)setupTableView
{
    [self.tableview registerNib:[UINib nibWithNibName:@"QNWeChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNWeChatTableViewCellIndetifier"];
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableview.estimatedRowHeight = 70;
    [self.tableview reloadData];
}

- (void)chatRecordUpdate
{
    if (self.tableview) {
        [self loadData];
        [self.tableview reloadData];
    }
}
#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"QNWeChatTableViewCellIndetifier" cacheByIndexPath:indexPath configuration:^(QNWeChatTableViewCell * cell) {
        
        NSNumber *userID = self.dataSource[indexPath.row];
        
        NSArray *chatArray = [[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser:userID];
        
        [cell updateContent:[chatArray lastObject]];
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNWeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNWeChatTableViewCellIndetifier" forIndexPath:indexPath];
    
    NSNumber *userID = self.dataSource[indexPath.row];
    
    NSArray *chatArray = [[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser:userID];
    
    [cell updateContent:[chatArray lastObject]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *userID = self.dataSource[indexPath.row];
    
    NSArray *chatArray = [[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser:userID];
    
    QNChatModel *model = [chatArray lastObject];
    
    NSArray *array = model.otherPerson;
    
    QNAddressBookContactModel *person = [array lastObject];
    
    [self performSegueWithIdentifier:@"wechatListToChatDetail" sender:person];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除"
             handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 
                 NSNumber *userID = self.dataSource[indexPath.row];
                 [[QNDataSource shareDataSource] deleteARecordToUser:userID];
                 [self.dataSource removeObjectAtIndex:indexPath.row];
                 [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationTop];
    }]];
}

#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"wechatListToChatDetail"]) {
        
        QNChatMainPageViewController *vc = segue.destinationViewController;
        vc.personModel = sender;
    }
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
