//
//  QNDetailTagTableViewCell.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/20.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    modelA,
    modelB,
    modelC,
} QNDetailTagTableViewCellModel;

@interface QNDetailTagTableViewCell : UITableViewCell

@property (nonatomic) QNDetailTagTableViewCellModel model;
@property (strong, nonatomic) NSString *subTitle;

@end
