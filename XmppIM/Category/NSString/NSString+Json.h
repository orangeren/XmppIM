//
//  NSString+Json.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/**
 *  字典转json
 *
 *  @param dictionary 字典
 *
 *  @return json
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

/**
 *  数组转json
 *
 *  @param array 数组
 *
 *  @return json
 */
+ (NSString *)jsonStringWithArray:(NSArray *)array;

/**
 *  字符串转json
 *
 *  @param string 字符串
 *
 *  @return json
 */
+ (NSString *)jsonStringWithString:(NSString *)string;

@end
