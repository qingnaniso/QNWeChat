//
//  measureTextTool.h
//  QNWeChat
//
//  Created by smartrookie on 16/7/6.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface measureTextTool : NSObject

+ (instancetype)sharedInstance;
- (CGSize)measure:(NSAttributedString *)attrString widthLimit:(CGFloat)widthlimit;

@end
