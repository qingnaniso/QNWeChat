//
//  mainChatRecordModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

@interface MainChatRecordModel : QNBaseModel

@property (nonatomic, strong) NSString *headerImageURL;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *lastChatRecordString;

@end
 