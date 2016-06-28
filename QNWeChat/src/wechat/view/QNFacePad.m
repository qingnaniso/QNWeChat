//
//  QNFacePad.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/22.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFacePad.h"
#import "QNFaceSubPad.h"
#import "QNFacePadBottomView.h"

@interface QNFacePad () <UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *collectionDataSource;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) void (^clickBlock)(NSString *iconString);
@property (strong, nonatomic) void (^clickImageButtonBlock)(NSString *iconString);
@property (strong, nonatomic) void (^deleteBlock)(NSString *);
@property (copy, nonatomic) NSString *lastClickedButtonFaceString;

@property (strong, nonatomic) void (^addButtonBlock)();
@property (strong, nonatomic) void (^sendButtonBlock)();

@property (nonatomic) BOOL keyboardPop;
@property (nonatomic, strong) NSMutableArray *subPadViews;
@property (nonatomic, strong) QNFaceSubPad *lastPad;
@property (nonatomic, strong) QNFacePadBottomView *bottomView;

@end

@implementation QNFacePad

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubView];
    }
    return self;
    
}

- (void)initSubView
{
    [self initData];
    [self initButtons];
    [self initMainIconPad];
}

- (void)initData
{
    self.collectionDataSource = [self getDictionaryFromPlist];
    self.subPadViews = [NSMutableArray array];
}

- (void)initButtons
{
    self.bottomView = [[QNFacePadBottomView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.bottomView handleButtonClick:^(NSInteger idx) {
        
        QNFaceSubPad *subPad = self.subPadViews[idx];
        [self.scrollView setContentOffset:CGPointMake(subPad.frame.origin.x, 0) animated:NO];
        
    }];
    
    [self.bottomView handelAddButtonClicked:^{
        if (self.addButtonBlock) {
            self.addButtonBlock();
        }
    } sendButtonClicked:^{
        if (self.sendButtonBlock) {
            self.sendButtonBlock();
        }
    }];
}

- (void)initMainIconPad
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
        
    }];
    [self loadFace];
}

- (void)loadFace
{
    CGFloat totalContentWidth = 0.0;

    for (int i = 0; i < self.collectionDataSource.allKeys.count; i++) {
     
        CGFloat width = [QNFaceSubPad padWidthForType:(i==0?QNFaceSubPadQQFaceIcon:QNFaceSubPadQQFaceIconCustom)];
        
        QNFaceSubPad *subPad = [[QNFaceSubPad alloc] initWithFrame:CGRectMake(totalContentWidth, 0, width, CGRectGetHeight(self.frame) - 40) type:(i==0?QNFaceSubPadQQFaceIcon:QNFaceSubPadQQFaceIconCustom)];
        
        [self.scrollView addSubview:subPad];
        
        [self.subPadViews addObject:subPad];
        
        subPad.startPoint = CGPointMake(totalContentWidth, 0);
        
        totalContentWidth += width;
        
        subPad.endPoint = CGPointMake(totalContentWidth, 0);
        
        [subPad handleQQIconButtonClicked:^(NSString *iconString) {
            
            if (self.clickBlock) {
                self.clickBlock(iconString);
            }
            
        } commonIconButtonClicked:^(NSString *iconString) {
            
            if (self.clickImageButtonBlock) {
                self.clickImageButtonBlock(iconString);
            }
            
        } deleteButtonClicked:^(NSString *iconString) {
            if (self.deleteBlock) {
                self.deleteBlock(iconString);
            }
        }];
        
        if (i == 0) {
            self.lastPad = subPad;
        }
    }
    self.scrollView.contentSize = CGSizeMake(totalContentWidth, CGRectGetHeight(self.scrollView.frame));
}

-(void)handleIconButtonClicked:(void (^)(NSString *))buttonClickedBlock
        imageIconButtonClicked:(void (^)(NSString *))imageButtonClickedBlock
           deleteButtonClicked:(void (^)(NSString *))deleteButtonClickedBlock
{
    self.clickBlock = buttonClickedBlock;
    self.deleteBlock = deleteButtonClickedBlock;
    self.clickImageButtonBlock = imageButtonClickedBlock;
}

-(void)handelAddButtonClicked:(void (^)())addButtonClicked sendButtonClicked:(void (^)())sendMessageBlock
{
    self.addButtonBlock = addButtonClicked;
    self.sendButtonBlock = sendMessageBlock;
}

- (NSDictionary *)getDictionaryFromPlist
{
    NSDictionary *dic = [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceConfig" ofType:@"plist"]]];
    return dic;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint scrollViewOffSet = scrollView.contentOffset;
    [self.subPadViews enumerateObjectsUsingBlock:^(QNFaceSubPad*  _Nonnull subPad, NSUInteger idx, BOOL * _Nonnull stop) {
        if (scrollViewOffSet.x >= subPad.startPoint.x && scrollViewOffSet.x < subPad.endPoint.x) {
            if (self.lastPad != subPad) {
                NSLog(@"fan ye le ");
                self.lastPad = subPad;
            }
            [self.bottomView scrollToIndex:idx];
        }
    }];
}

@end


