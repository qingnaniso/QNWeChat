//
//  QNFriendCircleHeaderView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/22.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleHeaderView.h"

@interface QNFriendCircleHeaderView ()

@property (strong, nonatomic) NSDictionary *infoDic;

@end
@implementation QNFriendCircleHeaderView

-(instancetype)initWithDic:(NSDictionary *)infoDic
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    if (!infoDic) {
        self.infoDic = @{@"backgroundImage":@"",@"name":@"测试帐号",@"vatarImage":@""};
    }
    self.infoDic = infoDic;
    [self initSubViews];
    return self;
}

- (void)initSubViews
{
    // backgroundImageView
    UIImageView *bgrImageView = [[UIImageView alloc] init];
    [self addSubview:bgrImageView];
    
    [bgrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset= -40.f;
        
    }];
    
    bgrImageView.backgroundColor = [UIColor greenColor];
    
    // vatar Image View
    UIImageView *vatarImageView = [[UIImageView alloc] init];
    [self addSubview:vatarImageView];
    
    [vatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(bgrImageView.mas_right).offset = - 10;
        make.height.equalTo(@(80));
        make.width.equalTo(@(80));
        make.bottom.equalTo(bgrImageView.mas_bottom).offset = 20;
        
    }];
    
    vatarImageView.backgroundColor = [UIColor blueColor];
    
    // name label
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(vatarImageView.mas_left).offset= -20;
        make.bottom.equalTo(bgrImageView.mas_bottom).offset = -8;
        
    }];
    
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"测试账号一";
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [nameLabel sizeToFit];
}
@end




