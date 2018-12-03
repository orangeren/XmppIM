//
//  UIButton+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Add)

/**
 *  快速创建纯色按钮
 *
 *  @param frame   frame大小
 *  @param title   title
 *  @param titleColor   title颜色
 *  @param bgColor 背景颜色
 *
 *  @return self
 */
+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

/**
 *  给按钮设置内容图片  图片按钮  通常用于一个图片按钮，但是触控面积加大  里面作了图片大小和btn大小的处理
 *
 *  @param imgName  图片名字  传nil则没有效果，不会报错。若传入的图片名字在资源文件里面没有找到图片，则没有效果不报错
 */
- (void)setContentImageName:(NSString *)imgName;
- (void)setContentImage:(UIImage *)img;

/**
 *  创建按钮 带title 背景色
 *  @param titleStr     title
 */
+ (UIButton *)creadBtn:(NSString *)titleStr colorStr:(NSString *)colorStr;


@end
