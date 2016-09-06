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

@end
