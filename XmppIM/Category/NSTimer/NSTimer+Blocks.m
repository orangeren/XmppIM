//
//  NSTimer+Blocks.m
//
//  Created by Jiva DeVoe on 1/14/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "NSTimer+Blocks.h"


typedef BOOL (^NSTimerWrapBlockType)();


@implementation NSTimer (Blocks)


#pragma mark 创建NSTimer
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                                        target:(id)target
                                       repeats:(BOOL)inRepeats
                                         block:(void (^)(NSTimer *timer))inBlock {
    
    __weak typeof(target) weakTarget = target;
    NSTimerWrapBlockType wrapBlock = ^(NSTimer *timer) {
        if (!weakTarget) {
            return NO;
        }
        
        inBlock(timer);
        return YES;
    };
    
    return [self scheduledTimerWithTimeInterval:inTimeInterval
                                         target:self
                                       selector:@selector(handleTimeout:)
                                       userInfo:wrapBlock
                                        repeats:inRepeats];
}

#pragma mark 创建NSTimer
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
                               target:(id)target
                              repeats:(BOOL)inRepeats
                                block:(void (^)(NSTimer *timer))inBlock {
    __weak typeof(target) weakTarget = target;
    NSTimerWrapBlockType wrapBlock = ^(NSTimer *timer) {
        if (!weakTarget) {
            return NO;
        }
        
        inBlock(timer);
        return YES;
    };
    
    return [self timerWithTimeInterval:inTimeInterval
                                target:self
                              selector:@selector(handleTimeout:)
                              userInfo:wrapBlock
                               repeats:inRepeats];
}

#pragma mark - Private Method
#pragma mark 操作
+ (void)handleTimeout:(NSTimer *)inTimer {
    
    if (inTimer.userInfo) {
        NSTimerWrapBlockType wrapBlock = inTimer.userInfo;
        if (!wrapBlock(inTimer)) {
            [inTimer invalidate];
        }
    }
}

@end
