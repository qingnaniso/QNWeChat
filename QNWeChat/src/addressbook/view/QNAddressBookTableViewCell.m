//
//  QNAddressBookTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/17.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNAddressBookTableViewCell.h"

@interface QNAddressBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation QNAddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateContent:(QNAddressBookContactModel *)model
{
    [self.mainImageView setImageWithURL:[NSURL URLWithString:model.vatarURL] placeholder:nil];
    self.nameLabel.text = model.name;
}

@end
