//
//  ACHeadImageChooseOptionView.h
//  ArtCMP
//
//  Created by smartrookie on 15/8/25.
//  Copyright (c) 2015年 Art. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ACChooseHeadImageTypeFromAlbum,
    ACChooseHeadImageTypeFromTakePicture,
    ACChooseHeadImageTypeCancel,
} ACChooseHeadImageType;

typedef void (^ACHeadImageChooseOptionViewTypeBlock)(ACChooseHeadImageType);
@interface ACHeadImageChooseOptionView : UIView

- (void)show;
- (void)whenTapped:(void (^)(ACChooseHeadImageType))block;

@end
