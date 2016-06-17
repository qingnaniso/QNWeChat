//
//  QNAddressBookViewController.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNAddressBookViewController.h"
#import "pinyin.h"
#import "QNAddressBookContactModel.h"
#import "QNAddressBookTableViewCell.h"

@interface QNAddressBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionIndexArray;
@property (strong, nonatomic) NSMutableArray *modelArrayGroupedByFirstLetter;

@end

@implementation QNAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    self.dataSource = [[QNDataSource shareDataSource] getAddressBookContactList];
    NSMutableArray *nameArray = [NSMutableArray array];
    self.sectionIndexArray = [NSMutableArray array];
    self.modelArrayGroupedByFirstLetter = [NSMutableArray array];
    
    [self.dataSource enumerateObjectsUsingBlock:^(QNAddressBookContactModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.name];
    }];
    [nameArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
    
        NSString *firstLetter = [self firstLetterForString:name];
        
        if (![self.sectionIndexArray containsObject:firstLetter]) {
            [self.sectionIndexArray addObject:firstLetter];
        }
    }];
    
    self.sectionIndexArray = [NSMutableArray arrayWithArray:[self.sectionIndexArray sortedArrayUsingSelector:@selector(compare:)]];
    
    [self makeNamesArrayGroupedByFirstLetter];
}

- (void)makeNamesArrayGroupedByFirstLetter
{
    NSMutableArray *arrayByGrouped = [NSMutableArray array];
    
    [self.sectionIndexArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull firstLetterInSectionIndex, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *group = [NSMutableArray array];
        [arrayByGrouped addObject:group];
    }];
    
    WS(weakSelf);
    
    [self.dataSource enumerateObjectsUsingBlock:^(QNAddressBookContactModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *firstLetter = [weakSelf firstLetterForString:model.name];
        
        [self.sectionIndexArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull firstLetterInSectionIndex, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([firstLetter isEqualToString:firstLetterInSectionIndex]) {
                NSMutableArray *array = arrayByGrouped[idx];
                [array addObject:model];
            }
        }];
    }];
    self.modelArrayGroupedByFirstLetter = [arrayByGrouped copy];
}

- (NSString *)firstLetterForString:(NSString *)string
{
    NSString *firstLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
    return firstLetter;
}

-(void)initTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"QNAddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNAddressBookTableViewCellIdentifier"];
    self.tableView.allowsSelection = YES;
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = false;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexArray;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionIndexArray[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.modelArrayGroupedByFirstLetter[section];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionIndexArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNAddressBookTableViewCellIdentifier" forIndexPath:indexPath];
    
    NSArray *subGroupModelArray = self.modelArrayGroupedByFirstLetter[indexPath.section];
    
    QNAddressBookContactModel *model = subGroupModelArray[indexPath.row];
    
    [cell updateContent:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
