//
//  QNAddressBookContactModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/17.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

@interface QNAddressBookContactModel : QNBaseModel

@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *vatarURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *homeAddress;
@property (strong, nonatomic) NSArray *personalAlbum;
@property (strong, nonatomic) NSString *macroNumber;

@end
