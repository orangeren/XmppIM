//
//  NSString+Encrypto.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypto)

/**
 *  sha1加密 
 */
- (NSString *)sha1Encryp;


/**
 *  md5加密
 */
- (NSString *)md5Encryp;


/**
 *  SHA256加密
 */
- (NSString *)SHA256;


/**
 *  HMAC 带密钥加密
 */
- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;

@end
