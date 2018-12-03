//
//  NSString+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Add)
/**
 *  是否空字符串 没有任何字符
 *
 *  @return BOOL
 */
- (BOOL)isBlank;

/**
 *  是否是有效的字符串  包括空字符串
 *
 *  @return BOOL
 */
- (BOOL)isValid;

/**
 *  按指定字符串分割为数组
 *
 *  @param separatedStr 指定的字符串
 *
 *  @return NSArray
 */
- (NSArray *)divisionForArrayByString:(NSString *)separatedStr;

/**
 *  删除所有空格
 *
 *  @return NSString
 */
- (NSString *)removeAllSpace;

/**
 *  按指定字符数量 插入指定字符  当后面的字符串不足count值时 直接添加
 *
 *  @param insertStr 需要插入的字符串
 *  @param count     每隔多少字符插入
 *
 *  @return NSString
 */
- (NSString *)insertStr:(NSString *)insertStr cutCount:(int)count;

/**
 *  获取字符串长度
 *
 *  @param font 字体大小
 *
 *  @return CGSize
 */
- (CGSize)getStringSize:(UIFont *)font;
- (CGSize)getStringSize:(UIFont *)font contentSize:(CGSize)contentSize;

/**
 *  获取字符串宽度
 *
 *  @param font 字体大小
 *  @param height 控件高度
 *
 *  @return CGSize
 */
- (CGFloat)getStringWidth:(UIFont *)font height:(CGFloat)height;
/**
 *  获取字符串高度
 *
 *  @param font 字体大小
 *  @param width 控件宽
 *
 *  @return CGSize
 */
- (CGFloat)getStringHeight:(UIFont *)font width:(CGFloat)width;


/**
 *  空 转 @“”
 *
 *  @return NSString
 */
+ (NSString *)emptyHandling:(id)obj;


/**
 *  还原进度丢失的数据   如："9.7" = "9.699999999999999";
 *
 *  @return NSString
 */
- (NSString *)stringChangeToReductionPrecision;


@end
