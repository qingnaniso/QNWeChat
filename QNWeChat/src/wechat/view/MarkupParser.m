//
//  MarkupParser.m
//  TestCoreText
//
//  Created by smartrookie on 16/6/29.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "MarkupParser.h"
#import "IconFrame.h"

@interface MarkupParser();
@property (strong, nonatomic) NSMutableArray *iconsArray;
@property (nonatomic) __block NSUInteger deleteRangeOffSet;
@end

@implementation MarkupParser

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0f;
        self.images = [NSMutableArray array];
        self.iconsArray = [NSMutableArray array];
    }
    return self;
}

-(NSAttributedString *)attrStringFromMarkup:(NSString *)string
{
    NSMutableAttributedString *markup = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:@"\\[.+?\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularEx enumerateMatchesInString:string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, markup.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        IconFrame *icon = [[IconFrame alloc] init];
        icon.range = result.range;
        
        // [abc-11] tag's range
        NSRange range;
        range.location = result.range.location + 1;
        range.length = result.range.length - 2;
        NSString *imgName = [string substringWithRange:range];
        icon.iconName = imgName;
        
        [self.iconsArray addObject:icon];
    }];
    
    [self.iconsArray enumerateObjectsUsingBlock:^(IconFrame*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // replace [abc-11] with ""
        NSRange range;
        range.location = obj.range.location - self.deleteRangeOffSet;
        range.length = obj.range.length;
        [markup replaceCharactersInRange:range withString:@""];
        self.deleteRangeOffSet += obj.range.length;
        
        CTRunDelegateCallbacks imageCallBacks;
        imageCallBacks.version = kCTRunDelegateVersion1;
        imageCallBacks.getAscent = RunDelegateAscent;
        imageCallBacks.getDescent = RunDelegateDecent;
        imageCallBacks.getWidth = RunDelegateWidth;
        imageCallBacks.dealloc = RunDealloc;
        CTRunDelegateRef delegate = CTRunDelegateCreate(&imageCallBacks, (__bridge void * _Nullable)(obj.iconName));
        
        //placeholder with blank " "
        NSMutableAttributedString *blankAttr = [[NSMutableAttributedString alloc] initWithString:@" "];
        [blankAttr addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:NSMakeRange(0, 1)];
        CFRelease(delegate);
        
        [blankAttr addAttribute:@"imageName" value:obj.iconName range:NSMakeRange(0, 1)];
    
        [markup insertAttributedString:blankAttr atIndex:range.location];
        
        self.deleteRangeOffSet -= 1;
    }];
    
    CTFontRef font = CTFontCreateWithName(CFSTR("ArialMT"), 14, NULL);
    [markup addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, markup.length)];
    //lineBreakMode
    markup.lineBreakMode = NSLineBreakByCharWrapping;

    return markup;
}
-(NSAttributedString *)attrStringFromMarkupForMeasure:(NSString *)string
{
    NSMutableAttributedString *markup = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:@"\\[.+?\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularEx enumerateMatchesInString:string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, markup.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        IconFrame *icon = [[IconFrame alloc] init];
        icon.range = result.range;
        
        // [abc-11] tag's range
        NSRange range;
        range.location = result.range.location + 1;
        range.length = result.range.length - 2;
        NSString *imgName = [string substringWithRange:range];
        icon.iconName = imgName;
        
        [self.iconsArray addObject:icon];
    }];
    
    [self.iconsArray enumerateObjectsUsingBlock:^(IconFrame*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // replace [abc-11] with ""
        NSRange range;
        range.location = obj.range.location - self.deleteRangeOffSet;
        range.length = obj.range.length;
        [markup replaceCharactersInRange:range withString:@""];
        self.deleteRangeOffSet += obj.range.length;
        
        CTRunDelegateCallbacks imageCallBacks;
        imageCallBacks.version = kCTRunDelegateVersion1;
        imageCallBacks.getAscent = RunDelegateAscent;
        imageCallBacks.getDescent = RunDelegateDecent;
        imageCallBacks.getWidth = RunDelegateWidth;
        imageCallBacks.dealloc = RunDealloc;
        CTRunDelegateRef delegate = CTRunDelegateCreate(&imageCallBacks, (__bridge void * _Nullable)(obj.iconName));
        
        //placeholder with blank " "
        NSMutableAttributedString *blankAttr = [[NSMutableAttributedString alloc] initWithString:@"xix"];  //xix placeholder for icon image
        [blankAttr addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:NSMakeRange(0, 1)];
        CFRelease(delegate);
        
        [blankAttr addAttribute:@"imageName" value:obj.iconName range:NSMakeRange(0, 1)];
        
        [markup insertAttributedString:blankAttr atIndex:range.location];
        
        self.deleteRangeOffSet -= 1;
    }];
    
    CTFontRef font = CTFontCreateWithName(CFSTR("ArialMT"), 14, NULL);
    [markup addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, markup.length)];
    //lineBreakMode
    markup.lineBreakMode = NSLineBreakByCharWrapping;

    return markup;
}


CGFloat RunDelegateAscent(void *refcon) {
    return 5;
}
CGFloat RunDelegateDecent(void *refcon) {
    return 5;
}
CGFloat RunDelegateWidth(void *refcon) {
    return 18;
}
void RunDealloc(void *refcon) {
    
}

@end
