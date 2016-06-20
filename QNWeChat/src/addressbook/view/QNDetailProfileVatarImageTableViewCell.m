//
//  QNDetailProfileVatarImageTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDetailProfileVatarImageTableViewCell.h"

@interface QNDetailProfileVatarImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macroMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *macroNumber;

@end

@implementation QNDetailProfileVatarImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.macroMessageLabel.text = @"微信号:";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateContent:(QNAddressBookContactModel *)content
{
    self.nickNameLabel.text = content.name;
    self.macroNumber.text = @"123qqxiami";
    [self.mainImageView setImageWithURL:[NSURL URLWithString:content.vatarURL] placeholder:nil];
}

@end
