//
//  SearchHistoryData.h
//  XmppIM
//
//  Created by 任 on 2018/11/6.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MaxHistoryCount 10

@interface SearchHistoryData : NSObject

@property (nonatomic, strong) NSMutableArray *historyArr;

// Add
- (void)addHistoryData:(NSString *)itemStr;
// Delele
- (void)deleleHistoryData:(NSString *)itemStr;
// Remove All
- (void)removeHistoryData;
@end
