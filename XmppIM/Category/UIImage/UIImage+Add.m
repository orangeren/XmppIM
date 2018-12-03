//
//  UIImage+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "UIImage+Add.h"
#import "UIColor+Add.h"
#import "UIView+Add.h"

@implementation UIImage (Add)

#pragma mark 按尺寸 缩放图片
- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  scaleImage;
}

#pragma mark view转换成Image
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 创建纯色UIImage
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr
{
    return [UIImage normalBtnBackgroudImgForStatue:w height:h color:colorStr alpha:1.0];
}

#pragma mark 创建纯色UIImage
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr alpha:(float)al
{
    UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    imgView.backgroundColor = [UIColor colorWithHexString:colorStr];
    imgView.alpha = al;
    
    UIImage *bgImg = [UIImage getImageFromView:imgView];
    
    return bgImg;
}

+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

#pragma mark - 绘制纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(40, 40));
    [color setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0, 0, 40, 40));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

#pragma mark - 绘制纯色图片 带尺寸
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 获取 启动页 图片
+ (UIImage *)getAppLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    
    NSString *launchImage = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImage];
}


@end
