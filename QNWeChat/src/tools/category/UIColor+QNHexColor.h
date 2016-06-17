//
//  UIColor+QNHexColor.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/17.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QNHexColor)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

@end
