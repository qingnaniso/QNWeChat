//
//  QNAddressBookViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNAddressBookViewController.h"
#import "pinyin.h"

@interface QNAddressBookViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation QNAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hanyu = @"中国共产党万岁！";
    NSString *firstLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([hanyu characterAtIndex:0])];
    NSLog(@"%@",[firstLetter uppercaseString]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
