//
//  measureTextTool.m
//  QNWeChat
//
//  Created by smartrookie on 16/7/6.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "measureTextTool.h"
@interface measureTextTool()
@property (strong, nonatomic) UITextView *measureTextView;
@end
@implementation measureTextTool

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[measureTextTool alloc] init];
    });
    return instance;
}
- (CGSize)measure:(NSAttributedString *)attrString widthLimit:(CGFloat)widthlimit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.measureTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.measureTextView.showsVerticalScrollIndicator = NO;
        self.measureTextView.scrollEnabled = NO;
        self.measureTextView.editable = NO;
    });
    //ensure use safe in asynchronous thread
    @synchronized(self.measureTextView){
        self.measureTextView.frame = CGRectMake(0, 0, widthlimit, CGFLOAT_MAX);
        self.measureTextView.attributedText = attrString;
        [self.measureTextView.layoutManager ensureLayoutForTextContainer:self.measureTextView.textContainer];
        CGRect textBounds = [self.measureTextView.layoutManager usedRectForTextContainer:self.measureTextView.textContainer];
        CGFloat width =  (CGFloat)ceil(textBounds.size.width + self.measureTextView.textContainerInset.left + self.measureTextView.textContainerInset.right);
        CGFloat height = (CGFloat)ceil(textBounds.size.height + self.measureTextView.textContainerInset.top + self.measureTextView.textContainerInset.bottom);
        return CGSizeMake(width, height);
    }
}
@end
