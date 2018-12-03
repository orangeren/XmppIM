//
//  UIImage+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Add)

/**
 *  图片缩放
 *
 *  @param size 按尺寸 缩放图片
 *  @return self
 */
- (UIImage *)scaleToSize:(CGSize)size;


/**
 *  view转换成Image
 *
 *  @param view 要添加阴影效果的view
 */
+ (UIImage *)getImageFromView:(UIView *)view;

/**
 通用按钮
 */
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr;
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr alpha:(float)al;

/**
 *  创建UIImage
 *
 *  @param imageName 图片名
 *  @return 拉伸好的图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

/**
 *  创建纯色UIImage
 *  @param color 颜色
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 *  创建 启动页 UIImage
 *
 *  @return UIImage
 */
+ (UIImage *)getAppLaunchImage;

@end
