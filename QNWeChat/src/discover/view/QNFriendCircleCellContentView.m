//
//  QNFriendCircleCellContentView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleCellContentView.h"
#import "QNFriendCircleModel.h"

@implementation QNFriendCircleCellContentView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createYYLabel];
    }
    return self;
}

- (void)createYYLabel
{
    self.contentLabel = [[UILabel alloc] init];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_right);
    }];
    self.contentLabel.numberOfLines = 0;
}

- (void)updateContent:(QNFriendCircleModel *)content
{
    self.contentLabel.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试试测试测试测试测试测试测试测试测试测试测试测试测试测试";
}

@end
