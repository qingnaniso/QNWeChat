//
//  QNFriendCircleTableViewCell.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNFriendCircleModel.h"
#import "QNFriendCircleCellContentView.h"
#import "QNFriendCircleCellCommentView.h"
#import "QNFriendCircleStatusView.h"
#import "QNMacroVideoContentView.h"

@interface QNFriendCircleTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) QNFriendCircleCellContentView *cellContentView;
@property (strong, nonatomic) QNFriendCircleCellCommentView *commentView;
@property (strong, nonatomic) QNFriendCircleStatusView *statusView;

- (void)updateContent:(QNFriendCircleModel *)content;

@end
