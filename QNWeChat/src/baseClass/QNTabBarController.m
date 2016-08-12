//
//  QNTabBarController.m
//  QNWeChat
//
//  Created by smartrookie on 16/7/14.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNTabBarController.h"

@implementation QNTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
    self.selectedIndex = 0;
    self.tabBar.tintColor = [UIColor colorWithRed:38.0/255 green:192.0/255 blue:40.0/255 alpha:1.0];
}

- (void)initView
{
    if(self.viewControllers.count >= 4){
        
        UINavigationController* nav1 = [self.viewControllers objectAtIndex:0];
        
        nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_mainframeHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav1.tabBarItem.image = [[UIImage imageNamed:@"tabbar_mainframe"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav1.tabBarItem.title = @"微信";
        
        UINavigationController* nav2 = [self.viewControllers objectAtIndex:1];
        nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_contactsHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav2.tabBarItem.image = [[UIImage imageNamed:@"tabbar_contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav2.tabBarItem.title = @"通讯录";
        
        UINavigationController* nav3 = [self.viewControllers objectAtIndex:2];
        nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discoverHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav3.tabBarItem.image = [[UIImage imageNamed:@"tabbar_discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav3.tabBarItem.title = @"发现";
        
        UINavigationController* nav4 = [self.viewControllers objectAtIndex:3];
        nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_meHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav4.tabBarItem.image = [[UIImage imageNamed:@"tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav4.tabBarItem.title = @"我";
        
    }
    
}

@end
