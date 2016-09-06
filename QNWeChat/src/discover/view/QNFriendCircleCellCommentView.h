//
//  QNFriendCircleCellCommentView.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFriendCircleCellCommentView : UIView

/* myself action */
- (void)showLove;
- (void)hideLove;

/* others */
- (void)updateLoverList:(NSArray *)lovers;

@end
