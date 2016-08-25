//
//  QNMacroVideoContentView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/25.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNMacroVideoContentView.h"

@implementation QNMacroVideoContentView

-(void)updateContent:(id)content
{
    [super updateContent:content];
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@180);
    }];
    view.backgroundColor = [UIColor lightGrayColor];
}

@end
