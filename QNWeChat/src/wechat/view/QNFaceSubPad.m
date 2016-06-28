//
//  QNFaceSubPad.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/27.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFaceSubPad.h"

@interface QNFaceSubPad ()

@property (strong, nonatomic) NSDictionary *faceDataSourceDic;
@property (strong, nonatomic) void (^clickQQFaceButtonBlock)(NSString *iconString);
@property (strong, nonatomic) void (^clickcommonFaceButtonBlock)(NSString *iconString);
@property (strong, nonatomic) void (^deleteBlock)(NSString *);
@property (copy, nonatomic) NSString *lastClickedButtonFaceString;


@end

@implementation QNFaceSubPad

-(instancetype)initWithFrame:(CGRect)frame type:(QNFaceSubPadType)faceType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.faceType = faceType;
        self.userInteractionEnabled = YES;
        [self initSubView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:QNFaceSubPadQQFaceIcon];
}

- (void)initSubView
{
    [self initData];
    [self initfaceIcons];
}

- (void)initData
{
    self.faceDataSourceDic = [self getDictionaryFromPlist];
}

- (void)initfaceIcons
{
    if (self.faceType == QNFaceSubPadQQFaceIcon) {
        [self loadQQFaceIcons];
    } else {
        [self loadCommonIcons];
    }
}

- (void)loadQQFaceIcons
{
    int iconCountPerRow = 8;
    int iconRowCount = 3;
    CGFloat buttonPadding = 8.0;
    CGFloat buttonWidth =( kScreenWidth - ((iconCountPerRow + 1) * buttonPadding)) / iconCountPerRow;
    
    NSNumber *iconNumber = self.faceDataSourceDic[@"smiley_"];
    
    int scrollViewPage = (iconNumber.intValue /  (iconRowCount * iconCountPerRow - 1)) + ((iconNumber.intValue % (iconRowCount * iconCountPerRow - 1)) == 0 ? 0 : 1);
    
    /* all the icons */
    for (int i = 0; i < iconNumber.intValue; i++) {
        
        int currentPage = i / (iconRowCount * iconCountPerRow - 1);
        
        int currentPageIndex = i - (currentPage * (iconRowCount * iconCountPerRow - 1));
        
        int currentRow = currentPageIndex / iconCountPerRow;
        
        int currentRowIndex = currentPageIndex - iconCountPerRow * currentRow;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(currentPage * kScreenWidth + currentRowIndex * buttonWidth + ( currentRowIndex + 1) * buttonPadding, currentRow * buttonWidth + (currentRow + 1) * buttonPadding, buttonWidth, buttonWidth);
        
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"smiley_%i",i]] forState:UIControlStateNormal];
        
        [button setTag:1000 + i];
        
        [button setTarget:self action:@selector(qqIconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    /* all the GoBack button */
    for (int currentPage = 0; currentPage < scrollViewPage; currentPage++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (currentPage == scrollViewPage - 1) {
            
            int lastIconIndex = iconNumber.intValue % (iconRowCount * iconCountPerRow - 1);
            int lastIconRow = lastIconIndex / iconCountPerRow;
            int lastIconRowIndex = lastIconIndex % iconCountPerRow;
            
            button.frame = CGRectMake(currentPage * kScreenWidth + lastIconRowIndex * buttonWidth + (lastIconRowIndex + 1) * buttonPadding, (lastIconRow + 1)* buttonPadding + buttonWidth * lastIconRow + 5, 26, 26);
            
        } else {
            
            button.frame = CGRectMake(currentPage * kScreenWidth + iconCountPerRow * buttonPadding + (iconCountPerRow - 1) * buttonWidth, iconRowCount * buttonPadding + buttonWidth * (iconRowCount - 1) + 5, 26, 26);
        }
        
        [button setImage:[UIImage imageNamed:@"facePadgoBack"] forState:UIControlStateNormal];
        
        [button setTag:9000];
        
        [button setTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)loadCommonIcons
{
    int iconCountPerRow = 4;
    int iconRowCount = 2;
    CGFloat buttonPadding = 20.0;
    CGFloat buttonWidth =( kScreenWidth - ((iconCountPerRow + 1) * buttonPadding)) / iconCountPerRow;
    
    NSNumber *iconNumber = self.faceDataSourceDic[@"icon_"];
    
    /* all the icons */
    for (int i = 0; i < iconNumber.intValue; i++) {
        
        int currentPage = i / (iconRowCount * iconCountPerRow);
        
        int currentPageIndex = i - (currentPage * (iconRowCount * iconCountPerRow));
        
        int currentRow = currentPageIndex / iconCountPerRow;
        
        int currentRowIndex = currentPageIndex - iconCountPerRow * currentRow;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(currentPage * kScreenWidth + currentRowIndex * buttonWidth + ( currentRowIndex + 1) * buttonPadding, currentRow * buttonWidth + 15, buttonWidth, buttonWidth);
        
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%i_cover",i]] forState:UIControlStateNormal];
        
        [button setTag:2000 + i];
        
        [button setTarget:self action:@selector(commonIconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)qqIconButtonClicked:(UIButton *)button
{
    NSInteger tag = button.tag;
    if (self.clickQQFaceButtonBlock) {
        self.lastClickedButtonFaceString = [NSString stringWithFormat:@"[smiley_%i]",tag-1000];
        self.clickQQFaceButtonBlock([NSString stringWithFormat:@"[smiley_%i]",tag-1000]);
    }
}

- (void)deleteButtonClicked:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(self.lastClickedButtonFaceString);
    }
}

- (void)commonIconButtonClicked:(UIButton *)button
{
    NSInteger tag = button.tag;
    if (self.clickcommonFaceButtonBlock) {
        self.clickcommonFaceButtonBlock([NSString stringWithFormat:@"[icon_%i]",tag-2000]);
    }
}

-(void)handleQQIconButtonClicked:(void (^)(NSString *))qqButtonClickedBlock commonIconButtonClicked:(void (^)(NSString *))commonButtonClickedBlock deleteButtonClicked:(void (^)(NSString *))deleteButtonClickedBlock
{
    self.clickQQFaceButtonBlock = qqButtonClickedBlock;
    self.clickcommonFaceButtonBlock = commonButtonClickedBlock;
    self.deleteBlock = deleteButtonClickedBlock;
}

- (NSDictionary *)getDictionaryFromPlist
{
    NSDictionary *dic = [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceConfig" ofType:@"plist"]]];
    return dic;
}

+(NSInteger)padWidthForType:(QNFaceSubPadType)type
{
    NSDictionary *dic = [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceConfig" ofType:@"plist"]]];
    if (type == QNFaceSubPadQQFaceIcon) {
        
        int iconCountPerRow = 8;
        int iconRowCount = 3;
        
        NSNumber *iconNumber = dic[@"smiley_"];
        
        int scrollViewPage = (iconNumber.intValue /  (iconRowCount * iconCountPerRow - 1)) + ((iconNumber.intValue % (iconRowCount * iconCountPerRow - 1)) == 0 ? 0 : 1);
        
        return scrollViewPage * kScreenWidth;
        
    } else {
        
        int iconCountPerRow = 4;
        
        int iconRowCount = 2;
        
        NSNumber *iconNumber = dic[@"icon_"];
        
        int scrollViewPage = (iconNumber.intValue /  (iconRowCount * iconCountPerRow)) + ((iconNumber.intValue % (iconRowCount * iconCountPerRow)) == 0 ? 0 : 1);
        
        return scrollViewPage * kScreenWidth;
    }
}

@end
