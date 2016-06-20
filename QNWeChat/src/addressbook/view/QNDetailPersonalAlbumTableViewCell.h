//
//  QNDetailPersonalAlbumTableViewCell.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNAddressBookContactModel.h"

@interface QNDetailPersonalAlbumTableViewCell : UITableViewCell

- (void)updateContent:(QNAddressBookContactModel *)model;

@end
