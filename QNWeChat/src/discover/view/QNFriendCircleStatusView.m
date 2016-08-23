//
//  QNFriendCircleStatusView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleStatusView.h"

@interface QNFriendCircleStatusView ()

@property (strong, nonatomic) NSDictionary *infoDic;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *showCommentLoveButton;
@property (strong, nonatomic) UIView *assessView;
@property (nonatomic, assign) BOOL showAssessView;

@end

@implementation QNFriendCircleStatusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.clipsToBounds = NO;
    // time label
    self.timeLabel = [[UILabel alloc] init];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"22小时前";
    self.timeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //delete button
    self.deleteButton = [[UIButton alloc] init];
    [self addSubview:self.deleteButton];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.deleteButton setTitleColor:[UIColor colorWithR:88 G:108 B:148] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset = 15;
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //comment love button
    self.showCommentLoveButton = [[UIButton alloc] init];
    [self addSubview:self.showCommentLoveButton];
    [self.showCommentLoveButton setImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateNormal];
    [self.showCommentLoveButton addTarget:self action:@selector(showCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.showCommentLoveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //assessView
    self.assessView = [[UIView alloc] init];
    [self addSubview:self.assessView];
    self.assessView.backgroundColor = [UIColor blueColor];
    [self.assessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showCommentLoveButton.mas_left).offset = -3;
        make.centerY.equalTo(self.showCommentLoveButton.mas_centerY);
        make.width.equalTo(@0);
        make.height.equalTo(@40);
    }];
}

- (void)deleteButtonClicked:(UIButton *)btn
{
    NSLog(@"delete");
}

- (void)showCommentButtonClicked:(UIButton *)btn
{
    if (!self.showAssessView) {
        
        [self.assessView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@120);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
        self.showAssessView = YES;
    } else {
        [self.assessView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
        self.showAssessView = NO;
    }
}

@end


