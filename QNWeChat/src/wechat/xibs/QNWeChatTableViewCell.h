//
//  QNWeChatTableViewCell.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainChatRecordModel.h"

@interface QNWeChatTableViewCell : UITableViewCell

- (void)updateContent:(MainChatRecordModel *)model;

@end
