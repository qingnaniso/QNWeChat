//
//  QNWeChatTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNWeChatTableViewCell.h"
#import "SDWebImageCompat.h"

@interface QNWeChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastChatRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation QNWeChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateContent:(MainChatRecordModel *)model
{
    self.nickNameLabel.text = model.nickName;
    self.lastChatRecordLabel.text = model.lastChatRecordString;
    self.timeLabel.text = model.dateString;
    [self.mainImageView setImageWithURL:[NSURL URLWithString:model.headerImageURL] placeholder:nil];
}

@end
