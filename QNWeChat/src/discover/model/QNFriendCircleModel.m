//
//  QNFriendCircleModel.m
//  QNWeChat
//
//  Created by smartrookie on 16/8/24.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "QNFriendCircleModel.h"

@implementation QNFriendCircleModel

-(void)addPureText:(NSString *)text completionBlock:(void (^)())completionBlock
{
    self.contentText = text;
    self.modelID = [[NSString stringWithFormat:@"%@%@",text,[[NSDate date] stringWithISOFormat]] md5String];
    self.modelDate = [NSDate date];
    self.formatDateString = @"刚刚";
    self.modelType = modelTypeText;
    [[QNDataSource shareDataSource] addFriendCircleData:self completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

-(void)addMacroVideoWithURL:(NSURL *)fileURL contentText:(NSString *)contentText
{
    self.modelID = [fileURL.absoluteString md5String];
    self.modelDate = [NSDate date];
    self.formatDateString = @"刚刚";
    self.modelType = modelTypeMacroVideo;
    self.contentText = contentText;
    self.videoURL = fileURL;
    [[QNDataSource shareDataSource] addFriendCircleData:self completionBlock:^{
        
    }];
}

-(void)LoveThisModel
{
    QNFriendCircleModel *model = [[QNDataSource shareDataSource] getModelFromCacheByModelID:self.modelID];
    if (model) {
        self.ILoveThis = !model.ILoveThis;
    }
    [[QNDataSource shareDataSource] updateFriendCircleDataByModelID:self.modelID withModel:self];
}

-(BOOL)isLoveThisModel
{
    QNFriendCircleModel *model = [[QNDataSource shareDataSource] getModelFromCacheByModelID:self.modelID];
    return model.ILoveThis;
}

-(void)addCommentToModel:(NSString *)commentString
{
    NSArray *oldComment = self.commentArray;
    if (oldComment.count > 0) {
        NSMutableArray *oldArray = [NSMutableArray arrayWithArray:self.commentArray];
        NSDictionary *dic = @{@"commentPerson":@"测试姓名呵呵哒",@"commentContent":commentString,@"commentedPerson":@""};
        NSArray *newArray = @[dic];
        [oldArray insertObject:newArray atIndex:0];
        self.commentArray = oldArray;
    } else {
        NSDictionary *dic = @{@"commentPerson":@"测试姓名呵呵哒",@"commentContent":commentString,@"commentedPerson":@""};
        NSArray *newArray = @[dic];
        self.commentArray = newArray;
    }
    [[QNDataSource shareDataSource] updateFriendCircleDataByModelID:self.modelID withModel:self];
}

@end

