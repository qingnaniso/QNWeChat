//
//  ACHeadImageChooseDetailView.h
//  ArtCMP
//
//  Created by smartrookie on 15/8/25.
//  Copyright (c) 2015年 Art. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACHeadImageChooseOptionView.h"

@protocol ACHeadImageChooseDetailViewProtocal <NSObject>

- (void)didSelectChooseHeadImageStyle:(ACChooseHeadImageType)style;

@end
@interface ACHeadImageChooseDetailView : UIView

@property (nonatomic, weak) id<ACHeadImageChooseDetailViewProtocal> delegate;

@end
