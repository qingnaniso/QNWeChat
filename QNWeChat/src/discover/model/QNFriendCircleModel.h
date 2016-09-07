//
//  QNFriendCircleModel.h
//  QNWeChat
//
//  Created by smartrookie on 16/8/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNBaseModel.h"

@interface QNFriendCircleModel : QNBaseModel

@property (nonatomic, assign) QNFriendCircleModelType modelType;
@property (nonatomic, strong) NSString *modelID;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSArray<NSString *> *photosArray;  //use NSDataSource get the image with array's key.
@property (nonatomic, strong) NSDictionary *shareInfoDictionary;
@property (nonatomic, strong) NSDate *modelDate;
@property (nonatomic, strong) NSString *formatDateString;
@property (nonatomic, strong) NSArray *loverList;
@property (nonatomic, assign) BOOL ILoveThis;

/* @{@"commentPerson":@"personName",@"commentContent":@"blablabla...",@"commentedPerson":@"personName"} */
@property (nonatomic, strong) NSArray <NSDictionary *> *commentArray;

/* create model method */
- (void)addPureText:(NSString *)text completionBlock:(void (^)())completionBlock;
- (void)addMacroVideoWithURL:(NSURL *)fileURL contentText:(NSString *)contentText;

/* update model method */
- (void)LoveThisModel;
- (void)addCommentToModel:(NSString *)commentString;

@end
