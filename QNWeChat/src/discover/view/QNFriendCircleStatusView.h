//
//  QNFriendCircleStatusView.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFriendCircleStatusView : UIView

@property (strong, nonatomic) void (^deleteBlock)();
@property (strong, nonatomic) void (^loveBlock)();
@property (strong, nonatomic) void (^commentBlock)();

-(instancetype)initWithDic:(NSDictionary *)dic;
- (void)hideCommentView;

@end
