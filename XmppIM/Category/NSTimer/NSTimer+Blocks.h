//
//  @fileName  NSTimer+Blocks.h
//  @abstract  NSTimer 快捷回调
//  @author    李宪 创建于 2017/5/10.
//  @revise    李宪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
// PS:原作者的代码不支持自动释放NSTimer，已修改 by xianli
// https://github.com/jivadevoe/NSTimer-Blocks


#import <Foundation/Foundation.h>


@interface NSTimer (Blocks)



/**
 创建NSTimer

 @param inTimeInterval 时间
 @param target target
 @param inRepeats 是否重复
 @param inBlock 回调Block
 @return NSTimer
 */
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                                        target:(id)target
                                       repeats:(BOOL)inRepeats
                                         block:(void (^)(NSTimer *timer))inBlock;

/**
 创建NSTimer

 @param inTimeInterval 时间
 @param target target
 @param inRepeats 是否重复
 @param inBlock 回调Block
 @return NSTimer
 */
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
                               target:(id)target
                              repeats:(BOOL)inRepeats
                                block:(void (^)(NSTimer *timer))inBlock;

@end
