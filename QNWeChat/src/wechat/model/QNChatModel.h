//
//  QNChatModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

@class QNAddressBookContactModel;

typedef enum : NSUInteger {
    
    QNChatModelWord,        /* word chat */
    QNChatModelImage,       /* image */
    QNChatModelVoice,       /* voice */
    QNChatModelInfoTip,     
    QNChatModelVideo,
    QNChatModelGif,
    QNChatModelFile,
    QNChatModelShare,
    
} QNChatModelType;

@interface QNChatModel : QNBaseModel

@property (strong, nonatomic) NSString *chatID;
@property (nonatomic) QNChatModelType chatType;
@property (strong, nonatomic) NSString *chatContent;
@property (nonatomic) BOOL chatFromMe;
@property (strong, nonatomic) NSString *vatarURL;
@property (strong, nonatomic) NSString *gifImageName;
@property (strong, nonatomic) NSString *videoURL;
@property (nonatomic) int voiceDuring;
@property (strong, nonatomic) NSString *voiceURL;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *chatModelInfoTipContent;
@property (strong, nonatomic) QNAddressBookContactModel *master;        /* ME is chat master */
@property (strong, nonatomic) NSArray *otherPerson;

@end

