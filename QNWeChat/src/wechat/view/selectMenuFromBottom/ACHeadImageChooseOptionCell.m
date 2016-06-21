//
//  ACHeadImageChooseOptionCell.m
//  ArtCMP
//
//  Created by smartrookie on 15/8/25.
//  Copyright (c) 2015年 Art. All rights reserved.
//

#import "ACHeadImageChooseOptionCell.h"


@interface ACHeadImageChooseOptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine;

@end
@implementation ACHeadImageChooseOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)hideBottomLine
{
    self.imageLine.hidden = YES;
}

-(void)setTitle:(NSString *)title
{
    self.label.text = title;
}

@end
