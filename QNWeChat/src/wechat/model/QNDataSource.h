//
//  QNDataSource.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>

/* global datasource when have no network request */

@interface QNDataSource : YYCache

+ (instancetype)shareDataSource;

- (NSArray *)getWechatMainPageDataSourceByUser;

- (NSArray *)getAddressBookContactList;

@end
