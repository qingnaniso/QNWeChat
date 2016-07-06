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

@end
@implementation QNChatContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chatContentMaskView = [[UIImageView alloc] init];
    self.chatContentMaskView.image = [[UIImage imageNamed:@"chatMask"] stretchableImageWithLeftCapWidth:15 topCapHeight:20];
    [self addSubview:self.chatContentMaskView];
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
    
    [self.chatContentMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.vatarImage.mas_left).offset = -10.0f;
        make.top.equalTo(self).offset = 10.0f;
        make.width.equalTo([NSNumber numberWithFloat:size.width]);
        make.height.equalTo([self cellHeightForContent:model]);
        
    }];
    
    if (!self.flag) {
        
        CGRect frame = CGRectMake(2, 2, 150 - 15, [QNChatContentTableViewCell cellHeightForContent:model] - 20);
        CTView *ctView = [[CTView alloc] initWithFrame:frame originalString:model.chatContent];
        ctView.backgroundColor = [UIColor clearColor];
        [self.chatContentMaskView addSubview:ctView];
        self.flag = YES;
    }
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

