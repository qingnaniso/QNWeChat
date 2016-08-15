//
//  UIBarButtonItem+QNExtention.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/15.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (QNExtention)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action;

@end
