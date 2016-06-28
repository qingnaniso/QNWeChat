//
//  QNFacePadBottomView.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/27.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFacePadBottomView.h"

@interface QNFacePadBottomView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *plusButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) void (^addButtonBlock)();
@property (strong, nonatomic) void (^sendButtonBlock)();

@property (strong, nonatomic) void (^typeButtonClickedBlock)(NSInteger);
@property (strong, nonatomic) NSDictionary *iconsDic;
@property (strong, nonatomic) NSMutableArray *iconTypeButtons;

@end
@implementation QNFacePadBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self initSubView];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    [self initButtons];
    [self initScrollView];
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

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.plusButton).offset = 50.0f;;
        make.right.equalTo(self.sendButton).offset = -50.0f;
        make.top.equalTo(self);
        make.bottom.mas_equalTo(self);
        
    }];
    
    [self addTypeButtons];
}

- (void)addTypeButtons
{
    self.iconTypeButtons = [NSMutableArray array];
    self.iconsDic = [self getDictionaryFromPlist];
    [self.iconsDic.allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"type%i",(idx % 2)]] forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor whiteColor];
        
        btn.frame = CGRectMake(idx * 50, 0, 50, 40);
        
        [btn addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:btn];
        
        [self.iconTypeButtons addObject:btn];
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth - 100 + 1, 40);
    }];
    UIButton *button = [self.iconTypeButtons firstObject];
    [button setBackgroundColor:[UIColor grayColor]];

}

-(void)scrollToIndex:(NSInteger)idx
{
    [self.iconTypeButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger btnIdx, BOOL * _Nonnull stop) {
        if (idx == btnIdx) {
            [obj setBackgroundColor:[UIColor grayColor]];
        } else {
            [obj setBackgroundColor:[UIColor whiteColor]];
        }
    }];
}

- (void)typeButtonClicked:(UIButton *)button
{
    __block NSUInteger i;
    [self.iconTypeButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:button]) {
            i = idx;
            [obj setBackgroundColor:[UIColor grayColor]];
        } else {
            [obj setBackgroundColor:[UIColor whiteColor]];
        }
    }];
    
    self.typeButtonClickedBlock(i);
}

- (void)plusButtonClicked:(UIButton *)button
{
    if (self.addButtonBlock) {
        self.addButtonBlock();
    }
}

- (void)sendButtonClicked:(UIButton *)button
{
    if (self.sendButtonBlock) {
        self.sendButtonBlock();
    }
}

-(void)handelAddButtonClicked:(void (^)())addButtonClicked sendButtonClicked:(void (^)())sendMessageBlock
{
    self.addButtonBlock = addButtonClicked;
    self.sendButtonBlock = sendMessageBlock;
}

-(void)handleButtonClick:(void (^)(NSInteger))scrollBlock
{
    self.typeButtonClickedBlock = scrollBlock;
}

- (NSDictionary *)getDictionaryFromPlist
{
    NSDictionary *dic = [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceConfig" ofType:@"plist"]]];
    return dic;
}

@end


