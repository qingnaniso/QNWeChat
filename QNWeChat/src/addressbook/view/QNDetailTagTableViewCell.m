//
//  QNDetailTagTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDetailTagTableViewCell.h"

@interface QNDetailTagTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end
@implementation QNDetailTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(QNDetailTagTableViewCellModel)model
{
    switch (model) {
        case modelA:
            self.subLabel.hidden = YES;
            self.tagLabel.text = @"设置备注和标签";
            break;
        case modelB:
            self.tagLabel.text = @"地区";
            self.subLabel.text = @"北京 丰台";
            self.arrowImage.hidden = YES;
            break;
        case modelC:
            self.tagLabel.text = @"更多";
            self.subLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

@end
