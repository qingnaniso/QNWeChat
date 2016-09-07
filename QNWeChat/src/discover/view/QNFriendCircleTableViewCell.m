//
//  QNFriendCircleTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleTableViewCell.h"

@interface QNFriendCircleTableViewCell ()

@property (strong, nonatomic) QNFriendCircleModel *model;

@end

@implementation QNFriendCircleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupSubviews
{
    WS(weakSelf);
    //vatar
    self.headerImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset = 12;
        make.height.equalTo(@44);
        make.width.equalTo(@44);
        make.top.equalTo(self.contentView).offset = 12;
    }];
    self.headerImageView.backgroundColor = [UIColor lightGrayColor];
    
    //user name
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor colorWithR:88 G:108 B:148];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView);
        make.left.equalTo(self.headerImageView.mas_right).offset = 12;
    }];
    
    //contentView
    self.cellContentView = [[QNFriendCircleCellContentView alloc] init];
    [self.contentView addSubview:self.cellContentView];
    [self.cellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 10;
        make.right.equalTo(self.contentView.mas_right).offset = -10;
    }];
    
    //status view (time label \ delete button \ showCommentLoveButton)
    self.statusView = [[QNFriendCircleStatusView alloc] initWithDic:nil];
    [self.contentView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_bottom).offset = 10;
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset = -10;
        make.height.equalTo(@30);
    }];
    self.statusView.deleteBlock = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(deleteData:cell:)]) {
            [weakSelf.delegate deleteData:weakSelf.model cell:weakSelf];
        }
        [weakSelf.statusView hideCommentView];
    };
    
    self.statusView.loveBlock = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(showLove:cell:)]) {
            [weakSelf.delegate showLove:weakSelf.model cell:weakSelf];
        }
        [weakSelf.statusView hideCommentView];
    };
    
    self.statusView.commentBlock = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(comment:cell:)]) {
            [weakSelf.delegate comment:weakSelf.model cell:weakSelf];
        }
        [weakSelf.statusView hideCommentView];
    };
    
    //comment view
    self.commentView = [[QNFriendCircleCellCommentView alloc] init];
    [self.contentView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusView.mas_bottom);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset = -10;
        make.bottom.equalTo(self.contentView.mas_bottom).offset = -10;
    }];
    [self.contentView bringSubviewToFront:self.statusView];
}

- (void)updateContent:(QNFriendCircleModel *)content
{
    self.model = content;
    self.nameLabel.text = @"测试姓名呵呵哒";

    [self.cellContentView updateContent:content];
    [self.commentView updateContent:content];
}

@end






