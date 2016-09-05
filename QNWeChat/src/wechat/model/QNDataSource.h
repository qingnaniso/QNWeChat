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

+ (instancetype)shareDataSource;

- (NSArray *)getWechatMainPageDataSourceByUser:(NSNumber *)userID;  //chat content with some user

- (void)addWechatMainPageDataSourceByUser:(NSNumber *)userID objects:(NSArray *)contents;  //add chat record to some user;

- (NSArray *)getAddressBookContactList;  //get all addressbook users

- (void)addARecordToUser:(NSNumber *)userID;

- (BOOL)deleteARecordToUser:(NSNumber *)userID;

- (NSArray *)getCurrentChattingForAllUsers; //return array of userID

- (NSArray *)getDiscoverDataWithDictionaryArray;

- (NSArray<QNFriendCircleModel *> *)getFriendCircleData;

- (void)addFriendCircleData:(id)data completionBlock:(void (^)())block;

- (void)removeFriendCircleData:(id)data completionBlock:(void (^)())block;

@end
