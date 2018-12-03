//
//  UIColor+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "UIColor+Add.h"

@implementation UIColor (Add)

#pragma mark 16进制颜色#e26562转UIColor
+ (instancetype)colorWithHexString:(NSString *)color alp:(float)alp {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alp];
}

#pragma mark 16进制颜色#e26562转UIColor 默认alpha 为1.0
+ (instancetype)colorWithHexString:(NSString *)color {
    return [UIColor colorWithHexString:color alp:1.0f];
}

#pragma mark RGB数字转颜色带默认透明为1
+ (instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [self colorWithR:r g:g b:b flt:1];
}

#pragma mark RGB数字转颜色
+ (instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b flt:(CGFloat)flt {
    return [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:flt];
}

#pragma mark 随机色
+ (instancetype)randomColor {
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}


@end
