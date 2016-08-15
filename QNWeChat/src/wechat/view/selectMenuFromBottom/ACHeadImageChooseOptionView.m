//
//  ACHeadImageChooseOptionView.m
//  ArtCMP
//
//  Created by smartrookie on 15/8/25.
//  Copyright (c) 2015年 Art. All rights reserved.
//

#import "ACHeadImageChooseOptionView.h"
#import "ACHeadImageChooseDetailView.h"

@interface ACHeadImageChooseOptionView () <ACHeadImageChooseDetailViewProtocal>

@property (strong, nonatomic) ACHeadImageChooseDetailView *detailView;
@property (copy, nonatomic) ACHeadImageChooseOptionViewTypeBlock actionBlock;

@end

@implementation ACHeadImageChooseOptionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initSubView];
    return self;
}

- (void)initSubView
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0;
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTap)];
    [self addGestureRecognizer:backgroundTap];
}

-(void)whenTapped:(void (^)(ACChooseHeadImageType))block
{
    if (block) {
        self.actionBlock = block;
    }
}

- (void)show
{
    UIWindow *currentWindow = [UIApplication sharedApplication].windows[0];
    [currentWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(currentWindow);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [self showTableView];
}

-(void)hide
{
    WS(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
        CGRect tableViewFrame = _detailView.frame;
        tableViewFrame.origin.y += ((self.dataSource.count + 1) * 50 + 7);
        _detailView.frame = tableViewFrame;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_detailView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)backgroundViewTap
{
    [self hide];
}

- (void)showTableView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ACHeadImageChooseDetailView" owner:nil options:nil];
    _detailView = array[0];
    _detailView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (self.dataSource.count + 1) * 50 + 7);
    _detailView.delegate = self;
    _detailView.dataSource = self.dataSource;
    UIWindow *currentWindow = [UIApplication sharedApplication].windows[0];
    [currentWindow addSubview:_detailView];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect tableViewFrame = _detailView.frame;
        tableViewFrame.origin.y -= ((self.dataSource.count + 1) * 50 + 7);
        _detailView.frame = tableViewFrame;
    }];
}

#pragma mark - delegate function
-(void)didSelectChooseHeadImageStyle:(ACChooseHeadImageType)style
{
    switch (style) {
        case ACChooseHeadImageTypeCancel:
            [self hide];
            break;
        default:
            break;
    }
}

@end
