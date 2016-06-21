//
//  ACHeadImageChooseDetailView.m
//  ArtCMP
//
//  Created by smartrookie on 15/8/25.
//  Copyright (c) 2015年 Art. All rights reserved.
//

#import "ACHeadImageChooseDetailView.h"
#import "ACHeadImageChooseOptionCell.h"

@interface ACHeadImageChooseDetailView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ACHeadImageChooseDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initTableView];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initTableView];
}

- (void)initTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ACHeadImageChooseOptionCell" bundle:nil] forCellReuseIdentifier:@"ACHeadImageChooseOptionCellIdentifier"];
}

#pragma mark uitableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ACHeadImageChooseOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACHeadImageChooseOptionCellIdentifier" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setTitle:@"视频聊天"];
        } else {
            [cell setTitle:@"语音聊天"];
            [cell hideBottomLine];
        }
    } else {
        [cell setTitle:@"取消"];
        [cell hideBottomLine];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(didSelectChooseHeadImageStyle:)]) {
            [self.delegate didSelectChooseHeadImageStyle:indexPath.row];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectChooseHeadImageStyle:)]) {
            [self.delegate didSelectChooseHeadImageStyle:ACChooseHeadImageTypeCancel];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end











