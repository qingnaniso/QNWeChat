//
//  QNDataSource.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDataSource.h"
#import "QNAddressBookContactModel.h"

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
    return (NSArray *)[self objectForKey:@"WechatMainPageDataSourceList"];
}

- (void)addWechatMainPageDataSourceByUser
{
    
}

-(NSArray *)getAddressBookContactList
{
    NSMutableArray *contactList = [NSMutableArray array];

    if (![self containsObjectForKey:@"getAddressBookContactList"]) {
        
        NSArray *vatarURLArray = @[@"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU3skibAqt732QvILol4OibMRRNbbdrZFvtZHAdTbYzAYsQGet4K7Lr7jD/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU0Im5DRGnRwS0VwmbosibYodaHONTP2MxWN8SxHKrp65OMMqcH1lQz5T/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU29fFSor34SdM2R5MxBV3icTic6ABxx9lr141X5NRoXx8Cnww7wZBeRwN/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/HurH4elIxzK8umEoJiaSwCrcqn1aN40tG3Of7g2sHmx6MfLeVN6stTN8iaPnCB0Oxw/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU12T5d7VzzNqhMrTonGMJHRKSt4ywLuChMzE7A980tQk21kjHj5o67U/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU2mqc2B3SNibqr88e9WffbcDfhCMK6pQL0At7rc5xeKKvucrWcmPlrIq/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU10k3ScpZgicaSzypPOhWeicMqfunmEgLwhboF7UibXgdynguxSJ2dvXUr/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU2NV106GSMsukMd2ILXgxR4BBfQgSQOticwW0nrh1dnfjJaiaCtOgzxLq/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU2iamFaXIYIOkM7OibV3GccLvmgnFaTRxKSpco6eQSHCYASibKTmcHrAag/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU0ibiaKicrwF4PvbdR5KaTYoNpv7eqUjPwoiaavYicibzmZ94Qdlk8hH9A1xZ/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU3ibQNsxc0kOwEfKm7oIf0S73gEbx7zCCreaHWSZ6S81n4qgfhL4u7xia/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU0p08bdcmlhImhvGGhViceiaYlhjia5qAKYkUnnk2tebz0Gvo1GqcQq3Xib/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU29fFSor34SdM2R5MxBV3icTic6ABxx9lr141X5NRoXx8Cnww7wZBeRwN/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU0Im5DRGnRwS0VwmbosibYodaHONTP2MxWN8SxHKrp65OMMqcH1lQz5T/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU12T5d7VzzNqhMrTonGMJHRKSt4ywLuChMzE7A980tQk21kjHj5o67U/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU0ibiaKicrwF4PvbdR5KaTYoNpv7eqUjPwoiaavYicibzmZ94Qdlk8hH9A1xZ/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU29fFSor34SdM2R5MxBV3icTic6ABxx9lr141X5NRoXx8Cnww7wZBeRwN/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU2NV106GSMsukMd2ILXgxR4BBfQgSQOticwW0nrh1dnfjJaiaCtOgzxLq/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU29fFSor34SdM2R5MxBV3icTic6ABxx9lr141X5NRoXx8Cnww7wZBeRwN/0",
                                   @"http://mmocgame.qpic.cn/wechatgame/mEMdfrX5RU29fFSor34SdM2R5MxBV3icTic6ABxx9lr141X5NRoXx8Cnww7wZBeRwN/0"];
        
        NSArray *nameArray = @[@"张三",@"李四",@"王五",@"赵六",@"啊七",@"钱八",@"陈九",@"周十",@"吴十一",@"祁庆男",@"高十二",@"燕儿",@"黑蛋子太黑了",@"杜海洋大灰狼",@"而紫的",@"xbox360",@"破落户儿",@"科比布莱恩特",@"uber司机王师傅",@"爱美丽小姐ooxx！@＃"];
        
        
        [vatarURLArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            QNAddressBookContactModel *model = [[QNAddressBookContactModel alloc] init];
            model.vatarURL = obj;
            model.name = nameArray[idx];
            
            [contactList addObject:model];
        }];
        
        [self setObject:contactList forKey:@"getAddressBookContactList"];
        
        return contactList;
        
    } else {
        
        return (NSArray *)[self objectForKey:@"getAddressBookContactList"];
        
    }
}

@end
