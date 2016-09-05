//
//  QNFriendCirclePureTextCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/9/5.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCirclePureTextCell.h"

@implementation QNFriendCirclePureTextCell

-(void)updateContent:(QNFriendCircleModel *)content
{
    [super updateContent:content];
    [self.cellContentView.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cellContentView.mas_bottom).offset = 5;
    }];
}

@end
