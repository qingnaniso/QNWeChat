//
//  QNDiscoverTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/13.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDiscoverTableViewCell.h"

@interface QNDiscoverTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation QNDiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateContent:(NSDictionary *)contentDic
{
    self.mainImageView.image = [UIImage imageNamed:contentDic[@"icon"]];
    self.label.text = contentDic[@"name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
