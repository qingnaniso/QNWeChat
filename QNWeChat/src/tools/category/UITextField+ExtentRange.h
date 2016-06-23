//
//  UITextField+ExtentRange.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/23.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;

@end
