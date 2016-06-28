//
//  QNFacePadBottomView.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/27.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFacePadBottomView : UIView

- (void)handelAddButtonClicked:(void (^) ())addButtonClicked sendButtonClicked:(void (^) ())sendMessageBlock;

- (void)handleButtonClick:(void (^) (NSInteger))scrollBlock;

- (void)scrollToIndex:(NSInteger)idx;
@end
