//
//  QNFriendCircleCellCommentView.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleCellCommentView.h"
#import "YYLabel.h"

@interface QNFriendCircleCellCommentView ()

@property (strong, nonatomic) YYLabel *loverLabel;

@end

@implementation QNFriendCircleCellCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.loverLabel = [[YYLabel alloc] init];
        [self addSubview:self.loverLabel];
        self.backgroundColor = [UIColor colorWithR:243 G:243 B:245];
        self.loverLabel.textColor = Globle_WeChat_UserNameLabel_Color;
        self.loverLabel.font = [UIFont boldSystemFontOfSize:13];
        WS(weakSelf);
        self.loverLabel.textTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            weakSelf.loverLabel.backgroundColor = [UIColor lightGrayColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.loverLabel.backgroundColor = [UIColor clearColor];
            });
        };
    }
    return self;
}

-(void)updateLoverList:(NSArray *)lovers
{
    if (lovers && lovers.count > 0) {
        self.loverLabel.text = @"测试姓名呵呵哒";
        [self.loverLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset = 10;
            make.top.equalTo(self).offset = 5;
            make.bottom.equalTo(self).offset = -5;
        }];
    } else {
        [self.loverLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.loverLabel.text = @"";
    }
}

@end
