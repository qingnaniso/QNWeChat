//
//  QNChatContentTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/28.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNChatContentTableViewCell.h"
#import "CTView.h"
#define kEdgeOffSet 10;
@interface QNChatContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *vatarImage;
@property (strong, nonatomic) UIImageView *chatContentMaskView;
@property (nonatomic) BOOL flag;
@property (nonatomic, strong) CTView *ctView;

@end
@implementation QNChatContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chatContentMaskView = [[UIImageView alloc] init];
    self.chatContentMaskView.image = [[UIImage imageNamed:@"chatMask"] stretchableImageWithLeftCapWidth:15 topCapHeight:20];
    [self addSubview:self.chatContentMaskView];
    self.ctView =  [[CTView alloc] initWithFrame:CGRectZero originalString:@""];
    [self.chatContentMaskView addSubview:self.ctView];
    self.ctView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(CGFloat)cellHeightForContent:(QNChatModel *)model
{
    CGFloat height = 0;
    if (model.chatType == QNChatModelWord) {
        CGSize size = [CTView sizeForStringByParser:model.chatContent];
        height = size.height;
    }
    return height + 2 * kEdgeOffSet;
}

-(void)updateContent:(QNChatModel *)model
{

    [self.vatarImage setImageWithURL:[NSURL URLWithString:model.vatarURL] placeholder:nil];
        
    CGSize size = [CTView sizeForStringByParser:model.chatContent];
        
    [self.chatContentMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.vatarImage.mas_left).offset = -10.0f;
        make.top.equalTo(self).offset = 10.0f;
        make.width.equalTo([NSNumber numberWithFloat:size.width]);
        make.height.equalTo([self cellHeightForContent:model]);
        
    }];
    
    CGRect frame = CGRectMake(2, 2, 200 - 15, [QNChatContentTableViewCell cellHeightForContent:model] - 20);
    [self.ctView setChatString:model.chatContent];
    self.ctView.frame = frame;
    [self.ctView setNeedsDisplay];
}

- (NSNumber *)cellHeightForContent:(QNChatModel *)model
{
    CGFloat height = 0;
    if (model.chatType == QNChatModelWord) {
        CGSize size = [CTView sizeForStringByParser:model.chatContent];
        height = size.height;
    }
    return [NSNumber numberWithFloat:height];
}

@end

