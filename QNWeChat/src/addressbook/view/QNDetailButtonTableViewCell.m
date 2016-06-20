//
//  QNDetailButtonTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDetailButtonTableViewCell.h"

@interface QNDetailButtonTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoChatBtn;

@end

@implementation QNDetailButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sendMsgBtn.layer.cornerRadius = 6;
    self.videoChatBtn.layer.cornerRadius = 6;
    self.sendMsgBtn.backgroundColor = [UIColor colorWithRed:38.0/255 green:171.0/255 blue:40.0/255 alpha:1];
    self.contentView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1];
    self.videoChatBtn.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendMsgBtnClicked:(id)sender {
}

- (IBAction)videoChatBtnClicked:(id)sender {
}


@end
