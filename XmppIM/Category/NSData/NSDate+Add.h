//
//  NSDate+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Add)
/**
 *  时间戳转时间 字符串
 *
 *  @param formater  格式
 *  @param timestamp 时间戳
 *  @param isChinese 当时间是今天、昨天的时候  是否显示中文今天、昨天
 *
 *  @return 字符串
 */
+ (NSString *)timeStampReturnNSStringByFormater:(NSString *)formater timestamp:(long int)timestamp isChineseFormat:(BOOL)isChinese;
+ (NSString *)timeStampReturnNSStringByFormater:(NSString *)formater timestamp:(long int)timestamp;
+ (NSString *)timeStampDefaultFormaterReturnNSStringByTimestamp:(long int)timestamp;

/**
 *  日期字符串 转NSDate 输入的日期字符串形如：@"1992-05-21 13:08:08"  包含格式
 *
 *  @param dateString 日期字符串 输入的日期字符串形如：@"1992-05-21 13:08:08"
 *  @param formater   格式
 *
 *  @return NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString formater:(NSString *)formater;
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  NSDate转日期字符串  包含格式
 *  @param formater 格式
 *
 *  @return 输出的日期字符串形如：@"1992-05-21 13:08:08"
 */
- (NSString *)stringFormater:(NSString *)formater;

/**
 *  NSDate转日期字符串  默认格式
 *
 *  @return 输出的日期字符串形如：@"1992-05-21 13:08:08"
 */
- (NSString *)stringFromDate;

/**
 *  倒计时  如果时间到了  则返回空字符串
 *
 *  @return 字符串组合 x天x小时x分x秒
 */
- (NSString *)countDown;

/**
 *  比较
 *
 *  @return 差几天
 */
- (NSUInteger)daysAgo;

/**
 *  时间转时间戳
 *
 *  @param curDate 需要转的NSDate
 *
 *  @return 时间戳
 */
+ (long int)timeToTimestampByDate:(NSDate *)curDate;
- (long int)timeToTimestamp;

/**
 *  日期比较  返回相差的秒数
 *
 *  @param endDate 日期
 *
 *  @return 秒
 */
- (NSInteger)compareWithDate:(NSDate *)endDate;

- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)weekDay;
- (NSString *)weekCHDay;

- (BOOL)isToday;
- (BOOL)isYestday;

@end
