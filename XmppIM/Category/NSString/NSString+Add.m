//
//  NSString+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "NSString+Add.h" 

@implementation NSString (Add)

#pragma mark 是否空字符串 没有任何字符
- (BOOL)isBlank {
    return ([[self removeAllSpace] isEqualToString:@""]) ? YES : NO;
}

#pragma mark 是否是有效的字符串  包括空字符串
- (BOOL)isValid {
    return ([[self removeAllSpace] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

#pragma mark 按指定字符串分割为数组
- (NSArray *)divisionForArrayByString:(NSString *)separatedStr {
    return [self componentsSeparatedByString:separatedStr];
}

#pragma mark 删除所有空格
- (NSString *)removeAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 按指定字符数量 插入指定字符
- (NSString *)insertStr:(NSString *)insertStr  cutCount:(int)count {
    NSMutableString *insert_MulStr = [[NSMutableString alloc] init];
    
    NSUInteger length = [self length];
    if (length <= count) {
        return self;
    } else {
        NSUInteger insertCount = length / count;
        for (int i = 0; i <= insertCount; i++) {
            int fromIndex = i * count;
            if ( (fromIndex + count) > length) {
                NSString *str = [self substringFromIndex:fromIndex];
                [insert_MulStr appendString:[NSString stringWithFormat:@"%@",str]];
            } else {
                NSString *str = [self substringWithRange:NSMakeRange(fromIndex, count)];
                if ((fromIndex + count) == length) {
                    [insert_MulStr appendString:[NSString stringWithFormat:@"%@",str]];
                } else {
                    [insert_MulStr appendString:[NSString stringWithFormat:@"%@%@",str,insertStr]];
                }
            }
        }
    }
    
    return insert_MulStr;
}

#pragma mark 获取字符串长度
- (CGSize)getStringSize:(UIFont *)font {
    return [self getStringSize:font contentSize:CGSizeMake(1000.0, 1000.0)];
}

- (CGSize)getStringSize:(UIFont *)font contentSize:(CGSize)contentSize {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:contentSize
                                         options:
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return textSize;
}

- (CGFloat)getStringWidth:(UIFont *)font height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return textSize.width;
}

- (CGFloat)getStringHeight:(UIFont *)font width:(CGFloat)width {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return textSize.height;
}

/**
 *  空 转 @“”
 */
+ (NSString *)emptyHandling:(id)obj {
    NSString *string = [NSString stringWithFormat:@"%@", obj];
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        string = @"";
    }
    return string;
}

/**
 *  还原进度丢失的数据   如："9.7" = "9.699999999999999";
 */
- (NSString *)stringChangeToReductionPrecision {
    if (self == nil || [self isEqualToString:@""]) {
        return @"0.0";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return  [[formatter numberFromString:self] stringValue];
}

@end
