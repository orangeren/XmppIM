//
//  NSData+UTF8.h
//  iValet
//
//  Created by 任 on 2018/1/15.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (UTF8)

/**
 *  字符串转码 utf8
 *
 *  @return 字符串
 */
- (NSString *)utf8String;

@end
