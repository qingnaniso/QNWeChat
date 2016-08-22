//
//  QNBaseNavigationController.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/15.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseNavigationController.h"

@implementation QNBaseNavigationController

-(instancetype)init
{
    self = [super init];
    if (self) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    }
    return self;
}

-(void)awakeFromNib
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:58/255. green:54/255. blue:63/255. alpha:1]];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTranslucent:YES];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    return [super awakeFromNib];
}

@end
