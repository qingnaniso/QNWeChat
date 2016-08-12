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
#import "QNSearchResultViewController.h"
#import "QNDetailProfileViewController.h"

@interface QNAddressBookViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionIndexArray;
@property (strong, nonatomic) NSMutableArray *modelArrayGroupedByFirstLetter;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIView *searchMaskView;
@property (nonatomic) BOOL didClickedCancel;

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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
}

- (void)initSearchBar
{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:[[QNSearchResultViewController alloc] init]];
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索栏表头视图
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    //背景颜色
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:246.0/255 alpha:1.0]]; /* remove top and bottom black lines */
    
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];    /* set edit cursor color which come from wechat ios client. */
    [searchField setTintColor:[UIColor colorWithRed:38.0/255 green:192.0/255 blue:40.0/255 alpha:1.0]];
}

#pragma mark - UISearchBar Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!self.didClickedCancel) {
        if (!self.searchMaskView) {
            
            self.searchMaskView = [[UIView alloc] initWithFrame:self.view.frame];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
            imageView.image = [[self.view snapshotImage] imageByBlurLight];
            [self.searchMaskView addSubview:imageView];
            [self.view addSubview:self.searchMaskView];
            NSLog(@"update called");
        }
    }
    [searchController.searchBar becomeFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.didClickedCancel = NO;
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchMaskView.hidden = YES;
    self.didClickedCancel = YES;
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
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        return 50;

    } else {
        return 40;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subGroupModelArray = self.modelArrayGroupedByFirstLetter[indexPath.section];
    
    QNAddressBookContactModel *model = subGroupModelArray[indexPath.row];
    
    [self performSegueWithIdentifier:@"AddressToDetail" sender:model];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        if (firstLetter) {
            if (![weakSelf.sectionIndexArray containsObject:firstLetter]) {
                [weakSelf.sectionIndexArray addObject:firstLetter];
            }
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
        
        if (firstLetter) {
            [self.sectionIndexArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull firstLetterInSectionIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([firstLetter isEqualToString:firstLetterInSectionIndex]) {
                    NSMutableArray *array = arrayByGrouped[idx];
                    [array addObject:model];
                }
            }];
        }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    QNDetailProfileViewController *vc = segue.destinationViewController;
    vc.model = sender;
    
    
}


@end
