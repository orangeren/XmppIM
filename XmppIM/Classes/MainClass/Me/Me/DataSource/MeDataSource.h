//
//  MeDataSource.h
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kMeDataSourceName = @"kMeDataSourceName";
static NSString *kMeDataSourceIcon = @"kMeDataSourceIcon";
static NSString *kMeDataSourceTitle = @"kMeDataSourceTitle";

typedef enum {
    MeType_Me,
    MeType_Setting
} MeType;

@interface MeDataSource : NSObject
+ (NSArray *)meDataSource;
@end
