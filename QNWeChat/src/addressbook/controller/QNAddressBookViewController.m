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
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation QNAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    [self initSearchBar];
}

- (void)initData
{
    self.dataSource = [[QNDataSource shareDataSource] getAddressBookContactList];
    [self setupSectionIndexDataSource];
}

-(void)initTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"QNAddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"QNAddressBookTableViewCellIdentifier"];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 15;
    self.automaticallyAdjustsScrollViewInsets = false;  /* fix a top blank area bug in UITableView .. */
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth, 28)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1.0]]; /* remove top and bottom black lines */
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [searchField setTintColor:[UIColor colorWithRed:38.0/255 green:192.0/255 blue:40.0/255 alpha:1.0]];

    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
    backgroundView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1.0];
    [backgroundView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = backgroundView;
}

#pragma mark - UITableView Delegate and DataSource

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexArray;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    titleLabel.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1.0];  /* color come from wechat ios client */
    titleLabel.text = [NSString stringWithFormat:@"    %@",self.sectionIndexArray[section]];  /* dont want a very left cause that is not elegent enough lol... */
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    return titleLabel;
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

#pragma mark - Seciton Index DataSource Factory

- (void)setupSectionIndexDataSource
{
    NSMutableArray *nameArray = [NSMutableArray array];
    self.sectionIndexArray = [NSMutableArray array];
    self.modelArrayGroupedByFirstLetter = [NSMutableArray array];
    WS(weakSelf);
    
    [self.dataSource enumerateObjectsUsingBlock:^(QNAddressBookContactModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.name];
    }];
    
    [nameArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *firstLetter = [weakSelf firstLetterForString:name];
        
        if (![weakSelf.sectionIndexArray containsObject:firstLetter]) {
            [weakSelf.sectionIndexArray addObject:firstLetter];
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
