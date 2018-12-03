//
//  NSString+JudgeValidation.h
//  iValet
//
//  Created by 任 on 2018/9/25.
//  Copyright © 2018年 i代. All rights reserved.
//
//  验证有效性

#import <Foundation/Foundation.h>

@interface NSString (JudgeValidation)

// 是否只包含字母
- (BOOL)isOnlyLetters;

// 是否只包含数字
- (BOOL)isOnlyNumbers;

// 是否是有效的Email
- (BOOL)isEffectiveEmail;

// 判断是否是URL
- (BOOL)isEffectiveUrl;

// 是否是有效的手机号
- (BOOL)IsPhoneNumber;

// 是否是有效的身份证
- (BOOL)IsIdentityCard;

// 是否是有效的银行卡
- (BOOL)IsBankCard;

@end
