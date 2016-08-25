//
//  QNFriendCircleModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

@interface QNFriendCircleModel : QNBaseModel

@property (nonatomic, assign) QNFriendCircleModelType *modelType;
@property (nonatomic, strong) NSNumber *modelID;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSArray<NSString *> *photosArray;  //use NSDataSource get the image with array's key.
@property (nonatomic, strong) NSDictionary *shareInfoDictionary;

@end
