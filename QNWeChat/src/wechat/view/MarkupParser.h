//
//  MarkupParser.h
//  TestCoreText
//
//  Created by smartrookie on 16/6/29.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface MarkupParser : NSObject

@property (strong, nonatomic) NSString *font;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *strokeColor;
@property (nonatomic) float strokeWidth;

@property (strong, nonatomic) NSMutableArray *images;

- (NSAttributedString *)attrStringFromMarkup:(NSString *)string;
-(NSAttributedString *)attrStringFromMarkupForMeasure:(NSString *)string;

@end
