//
//  QNWeChatTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/16.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNWeChatTableViewCell.h"
#import "SDWebImageCompat.h"
#import "QNAddressBookContactModel.h"


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

-(void)updateContent:(QNChatModel *)model
{
    //ignore 1 to many chatModel temporary..
    
    NSArray *array = model.otherPerson;
    QNAddressBookContactModel *person = [array lastObject];
    self.nickNameLabel.text = person.name;
    self.lastChatRecordLabel.text = model.chatContent;
    self.timeLabel.text = [model.chatDate stringWithFormat:@"yy/MM/dd"];
    [self.mainImageView setImageWithURL:[NSURL URLWithString:person.vatarURL] placeholder:nil];
}

@end
