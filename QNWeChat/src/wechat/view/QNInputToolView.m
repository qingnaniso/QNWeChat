//
//  QNInputToolView.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/21.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNInputToolView.h"
#import "QNFacePad.h"
#import "UITextField+ExtentRange.h"

@interface QNInputToolView ()
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *voiceButton;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *faceButton;
@property (strong, nonatomic) UIButton *speakButton;
@property (strong, nonatomic) QNFacePad *facePad;
@property (strong, nonatomic) NSMutableString *textFieldContent;
@property (strong, nonatomic) void (^sendMessageBlock)(NSString *);
@property (strong, nonatomic) void (^sendVoiceBlock)(NSString *);
@property (strong, nonatomic) void (^sendPictureBlock)(NSString *);
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
    [self initFacePad];
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
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"voiceBtn"] forState:UIControlStateNormal];
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
    if (!self.speakButton) {
        self.speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.speakButton setBackgroundImage:[[UIImage imageNamed:@"voiceButtonBgd"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
        [self.speakButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self.speakButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        self.speakButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.speakButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.speakButton];
        [self.speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.voiceButton).offset = 38.0;
            make.right.equalTo(self.faceButton).offset = -40;
            make.centerY.equalTo(self);
            make.top.equalTo(self).offset = 7;
            make.bottom.equalTo(self).offset = -7;
        }];

        self.textField.hidden = YES;
        [self.textField resignFirstResponder];
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"faceButton"] forState:UIControlStateNormal];
    } else {
        [self.speakButton removeFromSuperview];
        self.speakButton = nil;
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"voiceBtn"] forState:UIControlStateNormal];
    }
}

- (void)initFacePad
{
    int iconCountPerRow = 8;
    int iconRowCount = 3;
    CGFloat buttonPadding = 8.0;
    CGFloat buttonWidth =( kScreenWidth - ((iconCountPerRow + 1) * buttonPadding)) / 8;
    CGFloat padHeight = buttonWidth * iconRowCount + buttonPadding * (iconRowCount + 1);
    
    self.facePad = [[QNFacePad alloc] initWithFrame:CGRectMake(0, 0, 100, padHeight + 50 + 10)];
    
    WS(weakSelf);
    
    [self.facePad handleIconButtonClicked:^(NSString *iconString) {
        
        weakSelf.textFieldContent = [NSMutableString stringWithString:weakSelf.textField.text];
        [weakSelf.textFieldContent appendString:iconString];
        weakSelf.textField.text = weakSelf.textFieldContent;

        
    } deleteButtonClicked:^(NSString *lastClickedFaceString){
        
        if (weakSelf.textFieldContent.length > 0 && [[weakSelf.textFieldContent substringFromIndex:[weakSelf textFieldCurrentCurseRange].location] isEqualToString:@"]"]) {
           
            NSRange beginRange = [weakSelf.textFieldContent rangeOfString:@"[smiley_" options:NSBackwardsSearch];
            NSLog(@"location=%i,lenth=%i",beginRange.location,beginRange.length);
            if (beginRange.length > 0) {
                
                NSRange curseRange = [weakSelf textFieldCurrentCurseRange];
                int faceStringLength = curseRange.location - beginRange.location;
                NSRange deleteRange;
                deleteRange.location = beginRange.location;
                deleteRange.length = faceStringLength + 1;
                
                [weakSelf.textFieldContent replaceCharactersInRange:deleteRange withString:@""];
                weakSelf.textField.text = weakSelf.textFieldContent;
            }
            
        } else {
            
            if (weakSelf.textField.text.length > 0) {
                
                [weakSelf textFieldDeleteCharactor];
            }
        }
        
    }];
    
    [self.facePad handelAddButtonClicked:^{
        
        if (weakSelf.sendMessageBlock) {
            weakSelf.sendMessageBlock(weakSelf.textField.text);
            weakSelf.textField.text = @"";
            weakSelf.textFieldContent = [NSMutableString string];
        }
        
    } sendButtonClicked:^{
        
        if (weakSelf.sendMessageBlock) {
            weakSelf.sendMessageBlock(weakSelf.textField.text);
            weakSelf.textField.text = @"";
            weakSelf.textFieldContent = [NSMutableString string];
        }
        
    }];
}

-(void)setQNInputToolViewSendMessageBlock:(void (^)(NSString *))QNInputToolViewSendMessageBlock
{
    self.sendMessageBlock = QNInputToolViewSendMessageBlock;
}

- (void)textFieldDeleteCharactor
{
    
    NSRange selectedRange = [self.textField selectedRange];
    
    selectedRange.length = 1;
    
    if (selectedRange.location != 0) {
        
        selectedRange.location = selectedRange.location - 1;
        NSString *str = [self.textField.text stringByReplacingCharactersInRange:selectedRange withString:@""];
        self.textField.text = self.textFieldContent = [NSMutableString stringWithString:str];
        NSRange afterRange;
        afterRange.location = selectedRange.location;
        afterRange.length = 0;
        [self.textField setSelectedRange:afterRange];
    }
}

- (NSRange)textFieldCurrentCurseRange
{
    NSRange selectedRange = [self.textField selectedRange];
    selectedRange.length = 1;
    if (selectedRange.location !=0) {
        selectedRange.location = selectedRange.location - 1;
    }
    return selectedRange;
}

- (void)addButtonClicked:(UIButton *)btn
{
    NSLog(@"add button clicked");
}

- (void)faceButtonClicked:(UIButton *)btn
{
    if (!self.textField.inputView) {
        
        self.textField.inputView = self.facePad;
        
        [self.textField reloadInputViews];
        
    } else {
        
        self.textField.inputView = nil;
        [self.textField reloadInputViews];
    }
}


- (void)initTextField
{
    self.textField = [[UITextField alloc] init];
    [self.textField setBackground:[[UIImage imageNamed:@"textFieldBgd"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f]];
    [self.textField setTintColor:[UIColor colorWithRed:38.0/255 green:192.0/255 blue:40.0/255 alpha:1.0]];
    self.textField.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton).offset = 38.0;
        make.right.equalTo(self.faceButton).offset = -40;
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset = 7;
        make.bottom.equalTo(self).offset = -7;
    }];
    self.textFieldContent = [NSMutableString string];
}
- (void)initFaceButton
{

    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"faceButton"] forState:UIControlStateNormal];
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
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
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
