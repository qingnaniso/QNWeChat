//
//  QNWeChatRootViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNWeChatRootViewController.h"
#import "QNWeChatTableViewCell.h"


@interface QNWeChatRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation QNWeChatRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupTableView];
}

- (void)loadData
{
    self.dataSource = [NSMutableArray arrayWithArray:[[QNDataSource shareDataSource] getWechatMainPageDataSourceByUser]];
}

- (void)setupTableView
{
    [self.tableview registerNib:[UINib nibWithNibName:@"QNWeChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNWeChatTableViewCellIndetifier"];
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNWeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNWeChatTableViewCellIndetifier" forIndexPath:indexPath];
    
    [cell updateContent:self.dataSource[indexPath.row]];
    
    return cell;
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
