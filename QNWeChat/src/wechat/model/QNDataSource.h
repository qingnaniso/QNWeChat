//
//  QNDataSource.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>

/* global datasource when have no network request */
@class QNFriendCircleModel;
@interface QNDataSource : YYCache

/* init */

+ (instancetype)shareDataSource;

/* main page */

- (NSArray *)getWechatMainPageDataSourceByUser:(NSNumber *)userID;  //chat content with some user

- (void)addWechatMainPageDataSourceByUser:(NSNumber *)userID objects:(NSArray *)contents;  //add chat record to some user;

/* addressBook methods */

- (NSArray *)getAddressBookContactList;  //get all addressbook users

- (void)addARecordToUser:(NSNumber *)userID;

- (BOOL)deleteARecordToUser:(NSNumber *)userID;

- (NSArray *)getCurrentChattingForAllUsers; //return array of userID

- (NSArray *)getDiscoverDataWithDictionaryArray;

/* Friend Circle methods*/

- (NSArray<QNFriendCircleModel *> *)getFriendCircleData;

- (void)addFriendCircleData:(id)data completionBlock:(void (^)())block;

- (void)removeFriendCircleData:(id)data completionBlock:(void (^)())block;

- (void)updateFriendCircleDataByModelID:(NSString *)modelID withModel:(QNFriendCircleModel *)model;

- (QNFriendCircleModel *)getModelFromCacheByModelID:(NSString *)modelID;

@end
