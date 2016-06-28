//
//  QNFacePad.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/22.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFacePad : UIView

/**
    buttonClickedBlock :        普通的icon
    imageButtonClickedBlock:    动图
    deleteButtonClickedBlock:   删除一个普通icon
 */
- (void)handleIconButtonClicked:(void (^) (NSString *iconString))buttonClickedBlock
         imageIconButtonClicked:(void (^) (NSString *iconString))imageButtonClickedBlock
            deleteButtonClicked:(void (^) (NSString *iconString))deleteButtonClickedBlock;

- (void)handelAddButtonClicked:(void (^) ())addButtonClicked sendButtonClicked:(void (^) ())sendMessageBlock;

@end
