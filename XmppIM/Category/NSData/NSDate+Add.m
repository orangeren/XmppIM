//
//  NSDate+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "NSDate+Add.h"

@implementation NSDate (Add)
static NSString *formater_String = @"yyyy-MM-dd hh:mm:ss";
static NSCalendar *_calendar = nil;

#pragma mark 时间戳转时间
+ (NSString *)timeStampReturnNSStringByFormater:(NSString *)formater timestamp:(long int)timestamp isChineseFormat:(BOOL)isChinese {
    // 用nsdate 类，将 时间错转化为 时间对象。
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    if (isChinese) {
        NSUInteger dayAgos_Int = [curDate daysAgo];
        if (dayAgos_Int == 0) {
            return @"今天";
        } else if (dayAgos_Int == 1) {
            return @"昨天";
        } else if (dayAgos_Int == 2) {
            return @"前天";
        }
    }
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = formater;
    NSString *dateString = [fmt stringFromDate:curDate];
    
    
    return dateString;
}

#pragma mark 时间戳转时间   默认显示中文
+ (NSString *)timeStampReturnNSStringByFormater:(NSString *)formater timestamp:(long int)timestamp {
    return [NSDate timeStampReturnNSStringByFormater:formater timestamp:timestamp isChineseFormat:YES];
}

#pragma mark 时间戳转时间 默认格式  默认显示中文
+ (NSString *)timeStampDefaultFormaterReturnNSStringByTimestamp:(long int)timestamp {
    return [NSDate timeStampReturnNSStringByFormater:formater_String timestamp:timestamp isChineseFormat:YES];
}

#pragma mark 时间转时间戳
+ (long int)timeToTimestampByDate:(NSDate *)curDate {
    return (long)[curDate timeIntervalSince1970];
}

#pragma mark 时间转时间戳
- (long int)timeToTimestamp {
    return (long)[self timeIntervalSince1970];
}

#pragma mark 比较
- (NSUInteger)daysAgo {
    //    NSCalendar *calendar = [[self class] sharedCalendar];
    //    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
    //                                               fromDate:self
    //                                                 toDate:[NSDate date]
    //                                                options:0];
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    
    NSUInteger day = (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
    
    return day;
    
    //    return [components day];
}

#pragma mark 是否今天
- (BOOL)isToday {
    NSUInteger dayAgos_Int = [self daysAgo];
    if (dayAgos_Int == 0) {
        return YES;
    }
    return NO;
}

#pragma mark 是否昨天
- (BOOL)isYestday {
    NSUInteger dayAgos_Int = [self daysAgo];
    if (dayAgos_Int == 1) {
        return YES;
    }
    return NO;
}


#pragma mark  日期字符串 转NSDate 输入的日期字符串形如：@"1992-05-21 13:08:08"  包含格式
+ (NSDate *)dateFromString:(NSString *)dateString formater:(NSString *)formater{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat: formater];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

#pragma mark 日期字符串 转NSDate 输入的日期字符串形如：@"1992-05-21 13:08:08"  默认格式
+ (NSDate *)dateFromString:(NSString *)dateString {
    return [NSDate dateFromString:dateString formater:formater_String];
}

#pragma mark NSDate转日期字符串  包含格式
- (NSString *)stringFormater:(NSString *)formater{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:formater];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}

#pragma mark 日期比较，返回相差的秒数
- (NSInteger)compareWithDate:(NSDate *)endDate {
    NSDate *startDate = self;
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    NSInteger months = [components month];
    NSInteger days = [components day] + months * 30;
    NSUInteger hours = [components hour];
    NSUInteger min = [components minute];
    NSUInteger sec = [components second];
    
    return sec + min * 60 + hours * 60 * 60 + days * 24 * 60 * 60;
}

#pragma mark NSDate转日期字符串  默认格式
- (NSString *)stringFromDate{
    return [self stringFormater:formater_String];
}

#pragma mark 这里主要参考NSDate+Helper的库做的
+ (NSCalendar *)sharedCalendar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
                _calendar = [NSCalendar currentCalendar];
            }
        }
    });
    return _calendar;
}

#pragma mark 倒计时
- (NSString *)countDown
{
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *now = [NSDate date];
    
    NSDate *startDate = now;
    NSDate *endDate = self;
    
    NSCalendar *gregorian = [[self class] sharedCalendar];
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    NSInteger months = [components month];
    NSInteger dayss = [components day]+months*30;
    NSUInteger hours = [components hour];
    NSUInteger min = [components minute];
    NSUInteger sec = [components second];
    if (dayss==0&&hours==0&&min==0&&sec==0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%li天%li小时%li分%li秒",(long)dayss,(long)hours,(long)min,(long)sec];
}

#pragma mark 年
- (NSUInteger)year {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [weekdayComponents year];
}

#pragma mark 月
- (NSUInteger)month {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [weekdayComponents month];
}

#pragma mark 日
- (NSUInteger)day {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [weekdayComponents day];
}

#pragma mark 小时
- (NSUInteger)hour {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
    return [weekdayComponents hour];
}

#pragma mark 分钟
- (NSUInteger)minute {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
    return [weekdayComponents minute];
}

#pragma mark 星期
- (NSUInteger)weekDay {
    NSDateComponents *weekdayComponents = [[[self class] sharedCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
    return [weekdayComponents weekday];
}

- (NSString *)weekCHDay {
    NSString *weekCH_Str = @"";
    NSInteger weekDay = [self weekDay];
    NSArray *weekCH_Arr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    weekCH_Str = [weekCH_Arr objectAtIndex:weekDay - 1];
    return weekCH_Str;
}

@end
