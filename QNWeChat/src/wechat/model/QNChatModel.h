//
//  QNChatModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

typedef enum : NSUInteger {
    QNChatModelWord,
    QNChatModelImage,
    QNChatModelVoice,
    QNChatModelInfoTip,
    QNChatModelVideo,
    QNChatModelGif,
} QNChatModelType;

@interface QNChatModel : QNBaseModel

@property (strong, nonatomic) NSString *chatContent;
@property (nonatomic) BOOL chatFromMe;
@property (strong, nonatomic) NSString *vatarURL;
@property (strong, nonatomic) NSString *gifImageName;
@property (strong, nonatomic) NSString *videoURL;
@property (strong, nonatomic) NSString *voiceURL;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *chatModelInfoTipContent;

@end
