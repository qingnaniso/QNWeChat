//
//  QNEnum.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#ifndef QNEnum_h
#define QNEnum_h

/*
 
 1、纯文字
 2、文字加单张大图
 3、文字加多张小图
 4、文字加分享链接（图加两行文字）
 5、文字加小视频
 6、纯文字链接 push到新页面
 
 */
typedef enum : NSUInteger {
    modelTypeText,
    modelTypeSinglePicture,
    modelTypeMutiPictures,
    modelTypeCommenShare,
    modelTypeMacroVideo,
    modelTypeTextLink,
} QNFriendCircleModelType;

#endif /* QNEnum_h */
