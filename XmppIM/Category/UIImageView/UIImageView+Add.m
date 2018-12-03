//
//  UIImageView+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "UIImageView+Add.h"
#import "UIColor+Add.h"
#import "UIView+Add.h"

@implementation UIImageView (Add)

#pragma mark 画线
+ (instancetype)initWithFrameForLineImageView:(CGRect)frame Color:(NSString *)colorStr alpha:(float)alpha
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    
    BOOL isH = YES;
    if (frame.size.width < frame.size.height) {
        isH = NO;
    }
    
    UIColor *uiColor = [UIColor colorWithHexString:colorStr];
    CGColorRef color = [uiColor CGColor];
    unsigned long numComponents = CGColorGetNumberOfComponents(color);
    
    float r_float = 0.0, g_float = 0.0, b_float = 0.0;
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        r_float = components[0];
        g_float = components[1];
        b_float = components[2];
    } else {
        r_float = 0.0;
        g_float = 0.0;
        b_float = 0.0;
    }
    
    UIGraphicsBeginImageContext(imgView.frame.size);
    [imgView.image drawInRect:CGRectMake(0, 0, imgView.width, imgView.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), imgView.width);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r_float, g_float, b_float, alpha);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);  //起点坐标
    if (isH) {
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), imgView.width, 0);   //终点坐标
    } else{
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, imgView.height);   //终点坐标
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imgView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgView;
}

#pragma mark 换色
- (void)drawLineWithColor:(NSString *)colorStr alpha:(float)alpha {
    self.image = [self createImageWithColor:[UIColor colorWithHexString:colorStr]];
    self.alpha = alpha;
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, self.width, self.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
