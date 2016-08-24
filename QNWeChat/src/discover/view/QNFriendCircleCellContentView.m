//
//  QNFriendCircleCellContentView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleCellContentView.h"

@implementation QNFriendCircleCellContentView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateContent:(id)content
{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@180);
    }];
    view.backgroundColor = [UIColor lightGrayColor];
}

@end
