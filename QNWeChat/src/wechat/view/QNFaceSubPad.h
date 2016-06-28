//
//  QNFaceSubPad.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/27.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QNFaceSubPadQQFaceIcon,
    QNFaceSubPadQQFaceIconCustom,
} QNFaceSubPadType;

@interface QNFaceSubPad : UIView

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) QNFaceSubPadType faceType;

+ (NSInteger)padWidthForType:(QNFaceSubPadType)type;

- (instancetype)initWithFrame:(CGRect)frame type:(QNFaceSubPadType)faceType;

- (void)handleQQIconButtonClicked:(void (^) (NSString *iconString))qqButtonClickedBlock
          commonIconButtonClicked:(void (^) (NSString *iconString))commonButtonClickedBlock
            deleteButtonClicked:(void (^) (NSString *iconString))deleteButtonClickedBlock;

@end
