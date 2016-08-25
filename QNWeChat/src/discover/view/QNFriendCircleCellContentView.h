//
//  QNFriendCircleCellContentView.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFriendCircleCellContentView : UIView

@property (strong, nonatomic) UILabel *contentLabel;
- (void)updateContent:(id)content;

@end
