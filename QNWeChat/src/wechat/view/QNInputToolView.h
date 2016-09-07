//
//  QNInputToolView.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QNInputToolViewDelegate;

@interface QNInputToolView : UIView

@property (nonatomic, weak) id<QNInputToolViewDelegate> delegate;

- (void)makeKeyBoardHidden;

- (void)showKeyboard;

- (void)simpleMode;

@end

@protocol QNInputToolViewDelegate <NSObject>

@required

- (void)inputToolView:(QNInputToolView *)inputView didSendMessage:(NSString *)message;

@optional

- (void)inputToolView:(QNInputToolView *)inputView didSendPicture:(NSString *)message;
- (void)inputToolViewDidSendVoice:(QNInputToolView *)inputView;
- (void)inputToolViewDidEndSendVoice:(QNInputToolView *)inputView;
- (void)inputToolViewDelegateFuction;

@end





