//
//  QNChatContentTableViewCell.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/28.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNChatModel.h"

@interface QNChatContentTableViewCell : UITableViewCell

+ (CGFloat)cellHeightForContent:(QNChatModel *)model;

- (void)updateContent:(QNChatModel *)model;

@end
