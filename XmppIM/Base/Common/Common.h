//
//  Common.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/2.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

// 设置导航栏的主题
+(void)setupNavTheme;

// Alert 弹框
+ (void)showAlert:(NSString *)msg;

// 与当前时间比较：显示-昨天、刚刚、今天等
// @param timestamp 时间戳
+ (NSString *)timeStr:(NSDate *)msgDate;

// 比较两个日期之间的差值
// toDate - fromDate
+ (NSInteger)differencewithDate:(NSString*)fromDate toDate:(NSString*)toDate;

#pragma mark - 图片相关

// 图片灰色显示
+ (UIImage *)grayImage:(UIImage *)sourceImage;

// 绘制纯色图片
+ (UIImage *)createColorImageWithColor:(UIColor *)color;

// 按比例 缩放图片
+ (UIImage *)scaleImage:(UIImage *)originalImage scale:(CGFloat)scale;

// 按尺寸 缩放图片
+ (UIImage *)scaleImage:(UIImage *)originalImage toSize:(CGSize)size;



#pragma mark - 计算文本的 宽 高

//根据内容大小获取NString的宽, 高固定，获取宽
+ (CGSize)getWidthWithString:(NSString *)string fontSize:(float)fontSize;

//根据内容大小获取NString的高, 宽固定，获取高
+ (CGSize)getHeightWithString:(NSString *)string setWidth:(float)width fontSize:(float)fontSize;


@end
