//
//  Common.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/2.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "Common.h"

@implementation Common

// 设置全局导航栏的主题
+(void)setupNavTheme {
    // 设置导航样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 1.设置导航条的背景
    // 注：高度不会拉伸，宽度会拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBg_darkGray"] forBarMetrics:UIBarMetricsDefault];
    // 2.设置导航栏的字体
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
    
    /*
     设置全局「状态栏」的样式
     1.Info.plist文件中添加字段：View controller-based status bar appearance = NO;
     2.添加下句代码
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


// Alert 弹框
+ (void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

// 与当前时间比较：显示-昨天、刚刚、今天等
+ (NSString *)timeStr:(NSDate *)msgDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFmt.dateFormat = @"今天 HH:mm";
    } else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    } else {
        //昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    return [dateFmt stringFromDate:msgDate];
}  


// 比较两个日期之间的差值
// toDate - fromDate
+ (NSInteger)differencewithDate:(NSString*)fromDate toDate:(NSString*)toDate {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [fmt dateFromString:fromDate];
    NSDate *date2 = [fmt dateFromString:toDate];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:date1 toDate:date2 options:0];
     
    if (cmps.year != 0 || cmps.month != 0 || cmps.day != 0 || cmps.hour != 0) {
        return 300000; 
    }
    return cmps.minute*60 + cmps.second;
}


#pragma mark - 图片相关

// 图片灰色显示
+ (UIImage *)grayImage:(UIImage *)sourceImage {
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

// 绘制纯色图片
+ (UIImage *)createColorImageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(40, 40));
    [color setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0, 0, 40, 40));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

// 按比例 缩放图片
+ (UIImage *)scaleImage:(UIImage *)originalImage scale:(CGFloat)scale {
    CGSize size = CGSizeMake(originalImage.size.width * scale, originalImage.size.height * scale);
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  scaleImage;
}

// 按尺寸 缩放图片
+ (UIImage *)scaleImage:(UIImage *)originalImage toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  scaleImage;
}

 

#pragma mark - 计算文本的 宽 高

//根据内容大小获取NString的宽
+ (CGSize)getWidthWithString:(NSString *)string fontSize:(float)fontSize {
    CGRect getTextWid = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil];
    return getTextWid.size;
}

//根据内容大小获取NString的高
+ (CGSize)getHeightWithString:(NSString *)string setWidth:(float)width fontSize:(float)fontSize {
    CGRect getTextHei;
    getTextHei.size.height = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size.height;
    return getTextHei.size;
}




@end













