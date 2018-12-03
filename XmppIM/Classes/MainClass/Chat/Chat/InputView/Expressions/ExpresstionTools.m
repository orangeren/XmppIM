//
//  ExpresstionTools.m
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ExpresstionTools.h"
#import "ExpressionConfig.h"

static NSDictionary *expressionDict;

@implementation ExpresstionTools

// 「图片」文本 -> 「文字」文本
+ (NSString *)parseAttributeTextToNormalString:(NSAttributedString *)attStr {
    NSMutableString *normalString = [NSMutableString string];
    [attStr enumerateAttributesInRange:NSMakeRange(0, attStr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        ExpressionTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) {   //图片
            [normalString appendString:attachment.text];
        } else {            //文字
            NSAttributedString *attrStr = [attStr attributedSubstringFromRange:range];
            [normalString appendString:attrStr.string];
        }
    }];
    //NSLog(@"普通文本 - %@",normalString);
    return normalString;
}

// 「文字」文本 -> 「图片」文本
+ (NSAttributedString *)generateAttributeStringWithOriginalString:(NSString *)originStr fontSize:(CGFloat)fontSize {
    NSError *error = NULL;
    NSMutableAttributedString *resultAttrStr = [[NSMutableAttributedString alloc] initWithString:originStr];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\u4e00-\u9fa5]{1,}\\]" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSArray *results = [regex matchesInString:originStr options:NSMatchingReportCompletion range:NSMakeRange(0, originStr.length)];
    if (results) {
        for (NSTextCheckingResult *result in results.reverseObjectEnumerator) {
            NSRange resultRange = [result rangeAtIndex:0];
            NSString *resultImageName = [originStr substringWithRange:resultRange];
            NSLog(@"resultImageName - %@", resultImageName);
            //
            ExpressionTextAttachment *attachment = [[ExpressionTextAttachment alloc] initWithData:nil ofType:nil];
            attachment.image = [UIImage imageNamed:[self getExpressionNameWithImageName:resultImageName]];
            attachment.text = [self getExpressionNameWithImageName:resultImageName];
            attachment.bounds = CGRectMake(0, -6, fontSize+10, fontSize+10);
            NSAttributedString *expressionAttrStr = [NSAttributedString attributedStringWithAttachment:attachment];
            //
            [resultAttrStr replaceCharactersInRange:resultRange withAttributedString:expressionAttrStr];
        }
        
    }
    return resultAttrStr;
}

// 通过图片名 获取 表情名
+ (NSString *)getExpressionNameWithImageName:(NSString *)imageName {
    if (!expressionDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ExpressionNameList.plist" ofType:nil];
        expressionDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return expressionDict[imageName];
}
// 通过表情名 获取 图片名
+ (NSString *)getImageNameWithExpressionName:(NSString *)expressionName {
    if (!expressionDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ExpressionNameList.plist" ofType:nil];
        expressionDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return expressionDict[expressionName];
}

@end
