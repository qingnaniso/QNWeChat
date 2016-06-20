//
//  QNDetailProfileViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDetailProfileViewController.h"
#import "QNDetailProfileVatarImageTableViewCell.h"
#import "QNDetailTagTableViewCell.h"
#import "QNDetailPersonalAlbumTableViewCell.h"
#import "QNDetailButtonTableViewCell.h"
#import "QNDetailTableViewFooterView.h"

@interface QNDetailProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QNDetailProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"QNDetailProfileVatarImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNDetailProfileVatarImageTableViewCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QNDetailTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNDetailTagTableViewCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QNDetailPersonalAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNDetailPersonalAlbumTableViewCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QNDetailTableViewFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"QNDetailTableViewFooterViewIdentifier"];
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
}

#pragma mark - UITableView Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else if (indexPath.section == 1) {
        return 40;
    }
    else {
        
        if (indexPath.row == 0) {
            return 40;
        }
        else if (indexPath.row == 1) {
            return 80;
        }
        else {
            return 40;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 130;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        QNDetailProfileVatarImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNDetailProfileVatarImageTableViewCellIdentifier" forIndexPath:indexPath];
        [cell updateContent:self.model];
        return cell;
    }
    else if (indexPath.section == 1) {
        
        QNDetailTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNDetailTagTableViewCellIdentifier" forIndexPath:indexPath];
        cell.model = modelA;
        return cell;
    }
    else {
        
        if (indexPath.row == 0) {
            
            QNDetailTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNDetailTagTableViewCellIdentifier" forIndexPath:indexPath];
            cell.model = modelB;
            return cell;
            
        } else if (indexPath.row == 1) {
            
            QNDetailPersonalAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNDetailPersonalAlbumTableViewCellIdentifier" forIndexPath:indexPath];
            [cell updateContent:self.model];
            return cell;
            
        }else {
            
            QNDetailTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNDetailTagTableViewCellIdentifier" forIndexPath:indexPath];
            cell.model = modelC;
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        QNDetailTableViewFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QNDetailTableViewFooterViewIdentifier"];
        footer.QNDetailTableViewFooterViewBtnBlock = ^(QNDetailFooterBtnType type){
            if (type == QNDetailFooterBtnTypeSendMsg) {
                NSLog(@"发消息");
            } else {
                NSLog(@"视频聊天");
            }
        };
        return footer;
    } else {
        return nil;
    }
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
