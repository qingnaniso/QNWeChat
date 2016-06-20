//
//  QNDetailPersonalAlbumTableViewCell.m
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNDetailPersonalAlbumTableViewCell.h"

@interface QNDetailPersonalAlbumTableViewCell   ()

@property (weak, nonatomic) IBOutlet UILabel *personalAlbumLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *personalAlbums;

@end
@implementation QNDetailPersonalAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.personalAlbumLabel.text = @"个人相册";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)updateContent:(QNAddressBookContactModel *)model
{
    [model.personalAlbum enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.personalAlbums[idx];
        [imageView setImageWithURL:[NSURL URLWithString:obj] placeholder:nil];
    }];

}

@end
