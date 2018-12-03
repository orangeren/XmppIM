//
//  IMAppCache.m
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMAppCache.h"

#define UnreadNum @"UnreadNum" // 未读数 key


@implementation IMAppCache
singleton_implementation(IMAppCache);



//////////////////// 未读数 ////////////////////
//保存 未读数
+(void)saveUnreadNumToSanbox:(NSMutableDictionary *)dict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:UnreadNum];
    [defaults synchronize];
}

//获取 未读数
+(NSDictionary *)getUnreadNumFromSanbox {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:UnreadNum];
    return dict;
}

//计算未读消息 总数
+(int)allUnreadNum {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getUnreadNumFromSanbox]];
    NSArray *values = dict.allValues;
    int count = 0;
    for (NSString *countStr in values) {
        count += [countStr intValue];
    }
    return count;
}


@end
