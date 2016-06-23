//
//  QNFacePad.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/22.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNFacePad : UIView

- (void)handleIconButtonClicked:(void (^) (NSString *iconString))buttonClickedBlock
            deleteButtonClicked:(void (^) (NSString *iconString))deleteButtonClickedBlock;

@end
