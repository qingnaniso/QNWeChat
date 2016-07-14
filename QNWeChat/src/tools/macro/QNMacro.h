//
//  QNMacro.h
//  QNWeChat
//
//  Created by smartrookie on 16/6/17.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#ifndef QNMacro_h
#define QNMacro_h


#endif /* QNMacro_h */

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self

#define kUserInterfaceIdiomIsPhone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kUserInterfaceIdiomIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kUserInterfaceIdiomIsRetina ([[UIScreen mainScreen] scale] >= 2.0)

#define kScreenIs4InchRetina        (kUserInterfaceIdiomIsRetina && ([UIScreen mainScreen].bounds.size.height == 568.0f))
#define kScreenIsnot35              ([[UIScreen mainScreen] bounds].size.height > 480)
#define kScreenIs35Inch             ([[UIScreen mainScreen] bounds].size.height == 480)

#define SCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define IS_IPHONE_4_OR_LESS (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_5_OR_AFTER (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH > 568.0)
#define IS_IPHONE_5_OR_BEFORE (kUserInterfaceIdiomIsPhone && SCREEN_MAX_LENGTH <= 568.0)

//坐标
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)