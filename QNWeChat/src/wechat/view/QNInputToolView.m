//
//  QNInputToolView.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNInputToolView.h"

@interface QNInputToolView ()
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *voiceButton;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *faceButton;
@end

@implementation QNInputToolView

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
    [self iniBackgroundView];
    [self initVoiceButton];
    [self initAddButton];
    [self initFaceButton];
    [self initTextField];
}

- (void)iniBackgroundView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [[UIImage imageNamed:@"inputViewBackg"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)initVoiceButton
{
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceButton setImage:[UIImage imageNamed:@"voiceBtn"] forState:UIControlStateNormal];
    [self.voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceButton];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset = 5.0;
        make.width.and.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
}

- (void)voiceButtonClicked:(UIButton *)btn
{
    
}

- (void)addButtonClicked:(UIButton *)btn
{
    
}

- (void)faceButtonClicked:(UIButton *)btn
{
    
}


- (void)initTextField
{
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.textField setTintColor:[UIColor colorWithRed:38.0/255 green:192.0/255 blue:40.0/255 alpha:1.0]];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton).offset = 38.0;
        make.right.equalTo(self.faceButton).offset = -40;
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset = 7;
        make.bottom.equalTo(self).offset = -7;
    }];
}
- (void)initFaceButton
{

    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setImage:[UIImage imageNamed:@"faceButton"] forState:UIControlStateNormal];
    [self.faceButton addTarget:self action:@selector(faceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.faceButton];
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton).offset = -40.0;
        make.width.and.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    
}
- (void)initAddButton
{
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset = -5.0;
        make.width.and.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
}

-(void)makeKeyBoardHidden
{
    if (self.textField && self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
}
@end
