//
//  QNDataSource.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDataSource.h"

@interface QNDataSource ()

@property (strong, nonatomic) YYCache *cache;

@end

@implementation QNDataSource

+(instancetype)shareDataSource
{
    static QNDataSource *dataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[QNDataSource alloc] initWithName:@"com.qiqingnan.cache.wechat"];
    });
    return dataSource;
}

/* 微信主页中一级列表数据 */
-(NSArray *)getWechatMainPageDataSourceByUser
{
    return (NSArray *)[self objectForKey:@"WechatMainPageDataSource"];
}

- (void)addWechatMainPageDataSourceByUser
{
    
}

@end
