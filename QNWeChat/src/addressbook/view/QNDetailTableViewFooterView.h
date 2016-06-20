//
//  QNDetailTableViewFooterView.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QNDetailFooterBtnTypeSendMsg,
    QNDetailFooterBtnTypeVideoChat,
} QNDetailFooterBtnType;

@interface QNDetailTableViewFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) void(^QNDetailTableViewFooterViewBtnBlock)(QNDetailFooterBtnType type);

@end
