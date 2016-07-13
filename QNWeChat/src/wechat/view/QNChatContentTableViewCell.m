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
@property (nonatomic, strong) UILabel *timeLabel;
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
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
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
    } else if (model.chatType == QNChatModelVoice) {
        height = 20;
    }
    return height + 2 * kEdgeOffSet;
}

-(void)updateContent:(QNChatModel *)model
{

    [self.vatarImage setImageWithURL:[NSURL URLWithString:model.vatarURL] placeholder:nil];
    
    switch (model.chatType) {
            
        case QNChatModelWord:
            {
                self.timeLabel.text = @"";
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
                break;
            }
            
        case QNChatModelVoice:
            {
                self.ctView.frame = CGRectZero;
                CGSize size = CGSizeMake(MIN(model.voiceDuring * 10 + 30, 200), 50);
                [self.chatContentMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.vatarImage.mas_left).offset = -10.0f;
                    make.top.equalTo(self).offset = 10.0f;
                    make.width.equalTo([NSNumber numberWithFloat:size.width]);
                    make.height.equalTo([self cellHeightForContent:model]);
                    
                }];
            
                [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.centerY.equalTo(self.chatContentMaskView);
                    make.right.equalTo(self.chatContentMaskView.mas_left).offset = -10.f;
                    
                }];
                
                self.timeLabel.text = [NSString stringWithFormat:@"%i\"",MAX(1, model.voiceDuring)];
                
                break;
            }
            
        default:
            break;
    }

    [self.ctView setNeedsDisplay];
}

- (NSNumber *)cellHeightForContent:(QNChatModel *)model
{
    CGFloat height = 0;
    if (model.chatType == QNChatModelWord) {
        CGSize size = [CTView sizeForStringByParser:model.chatContent];
        height = size.height;
    }   else if (model.chatType == QNChatModelVoice) {
        height = 40;
    }
    return [NSNumber numberWithFloat:height];
}

@end

