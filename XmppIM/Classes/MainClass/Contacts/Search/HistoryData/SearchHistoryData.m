//
//  SearchHistoryData.m
//  XmppIM
//
//  Created by 任 on 2018/11/6.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SearchHistoryData.h"

#define KEY_SearchHistory @"KEY_SearchHistory"


@implementation SearchHistoryData

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SearchHistory]];
    }
    return _historyArr;
}


// Add
- (void)addHistoryData:(NSString *)itemStr {
    // 1.去重
    if ([self.historyArr containsObject:itemStr]) {
        [self.historyArr removeObject:itemStr];
    }
    // 2.插入第0位
    [self.historyArr insertObject:itemStr atIndex:0];
    // 3.保留 MaxHistoryCount 条数据
    if (self.historyArr.count > MaxHistoryCount) {
        [self.historyArr removeObjectsInRange:NSMakeRange(MaxHistoryCount, self.historyArr.count-MaxHistoryCount)];
    }
    // 4.更新缓存
    [self saveHistoryData:self.historyArr];
}

// Delele
- (void)deleleHistoryData:(NSString *)itemStr {
    // 1.删除
    [self.historyArr removeObject:itemStr];
    // 2.更新缓存
    [self saveHistoryData:self.historyArr];
}

// Remove All
- (void)removeHistoryData {
    // 1.
    [self.historyArr removeAllObjects];
    // 2.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KEY_SearchHistory];
    [userDefaults synchronize];
}




#pragma mark - Private method
// 保存数据
- (void)saveHistoryData:(NSMutableArray *)historyArr {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:historyArr forKey:KEY_SearchHistory];
    [userDefaults synchronize];
}

@end
