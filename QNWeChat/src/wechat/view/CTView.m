//
//  CTView.m
//  TestCoreText
//
//  Created by smartrookie on 16/6/29.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>
#import "MarkupParser.h"
#import "measureTextTool.h"

@interface CTView ()
@property (strong, nonatomic) NSString *originalString;
@end

@implementation CTView

-(instancetype)initWithFrame:(CGRect)frame originalString:(NSString *)string
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.originalString = string;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    NSString *originalString = self.originalString;
    
    MarkupParser *parser = [[MarkupParser alloc] init];
    
    NSAttributedString *attString = [parser attrStringFromMarkup:originalString];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);

        CFArrayRef runArray = CTLineGetGlyphRuns(line);
        
        for (int j = 0; j < CFArrayGetCount(runArray); j++) {
        
            CTRunRef run = CFArrayGetValueAtIndex(runArray, j);
            NSDictionary *runDic = (__bridge NSDictionary *)CTRunGetAttributes(run);
            NSString *imageName = runDic[@"imageName"];
            
            if (imageName) {
                
                CGFloat runAscent;
                CGFloat runDescent;
                CGFloat runLeading;
                CGPoint lineOrigin = lineOrigins[i];
                
                CGRect runRect;
                runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);
                
                CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat y = lineOrigin.y - runDescent;
                CGFloat width = runRect.size.width;
                CGFloat height = runAscent + runDescent;
                
                runRect = CGRectMake(x,y,width,height);
                
                UIImage *image = [UIImage imageNamed:imageName];
                
                if (image) {
                    
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(18, 18);
                    imageDrawRect.origin.x = runRect.origin.x;
                    imageDrawRect.origin.y = lineOrigin.y - 4;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
}

+(CGSize)sizeForStringByParser:(NSString *)originalString
{
    MarkupParser *parser = [[MarkupParser alloc] init];

    NSAttributedString *attString = [parser attrStringFromMarkupForMeasure:originalString];
    
    CGSize boundingRect = [[measureTextTool sharedInstance] measure:attString widthLimit:200];

    return boundingRect;
}

- (void)setChatString:(NSString *)string
{
    self.originalString = [string copy];
    
}

@end

