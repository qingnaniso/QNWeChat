//
//  QNFacePad.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/22.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFacePad.h"
#import "QNFacePadChooseTypeCollectionViewCell.h"

@interface QNFacePad () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIButton *plusButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UICollectionView *collectionView; /* usage: choose face icon type (at pad bottom. can scroll horizontal) */
@property (strong, nonatomic) NSDictionary *collectionDataSource;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation QNFacePad

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self initSubView];
    }
    return self;
    
}

- (void)initSubView
{
    [self initData];
    [self initButtons];
    [self initCollectionView];
    [self initMainIconPad];
}

- (void)initData
{
    self.collectionDataSource = [self getDictionaryFromPlist];
}

- (void)initButtons
{
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.plusButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.plusButton setTitle:@"增加" forState:UIControlStateNormal];
    self.plusButton.backgroundColor = [UIColor whiteColor];
    [self.plusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.plusButton];
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        
    }];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.sendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.backgroundColor = [UIColor whiteColor];
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        
    }];
}

- (void)initCollectionView
{
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:[[UICollectionViewLayout alloc] init]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QNFacePadChooseTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QNInputFacePadIndentifier"];
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.plusButton).offset = 50;
        make.top.equalTo(self.plusButton);
        make.bottom.equalTo(self.plusButton);
        make.right.equalTo(self.sendButton).offset = -50;
        
    }];
}

- (void)initMainIconPad
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.mas_equalTo(self.plusButton.mas_top);
        
    }];
    
    NSNumber *iconNumber = self.collectionDataSource[@"smiley_"];
    
    int scrollViewPage = (iconNumber.intValue /  (3 * 8 - 1)) + ((iconNumber.intValue % (3 * 8 - 1)) == 0 ? 0 : 1);
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * scrollViewPage, CGRectGetHeight(self.scrollView.frame));
    
    CGFloat buttonWidth = 20.0;
    CGFloat buttonPadding = 5.0;
    
    for (int i = 0; i < iconNumber.intValue; i++) {
        
        int currentPage = i / (3 * 8 - 1);
        
        int currentPageIndex = i - (currentPage * (3 * 8 - 1));
        
        int currentRow = (currentPageIndex / 3) + ((currentPageIndex % 3) == 0 ? 0 : 1);
        
        int currentRowIndex = currentPageIndex - 8 * currentRow;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(currentPage * kScreenWidth + currentRowIndex * buttonWidth + ( currentRowIndex + 1) * buttonPadding, currentRow * buttonWidth, buttonWidth, buttonWidth);
        
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"smiley_%i",i]] forState:UIControlStateNormal];
        
        [self.scrollView addSubview:button];
        
    }
}

- (void)plusButtonClicked:(UIButton *)button
{
    NSLog(@"plusButtonClicked");
}

- (void)sendButtonClicked:(UIButton *)button
{
    NSLog(@"sendButtonClicked");
}

- (NSDictionary *)getDictionaryFromPlist
{
    NSDictionary *dic = [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceConfig" ofType:@"plist"]]];
    return dic;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataSource.allKeys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QNFacePadChooseTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QNInputFacePadIndentifier" forIndexPath:indexPath];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 40);
}


@end
