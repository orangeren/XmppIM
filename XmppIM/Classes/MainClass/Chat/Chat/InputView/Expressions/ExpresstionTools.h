//
//  ExpresstionTools.h
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpresstionTools : NSObject

// 「图片」文本 -> 「文字」文本
+ (NSString *)parseAttributeTextToNormalString:(NSAttributedString *)attStr;
// 「文字」文本 -> 「图片」文本
+ (NSAttributedString *)generateAttributeStringWithOriginalString:(NSString *)originStr fontSize:(CGFloat)fontSize;

// 通过图片名 获取 表情名
+ (NSString *)getExpressionNameWithImageName:(NSString *)imageName;
// 通过表情名 获取 图片名
+ (NSString *)getImageNameWithExpressionName:(NSString *)expressionName;

@end
