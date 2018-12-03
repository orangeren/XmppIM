//
//  SettingDataSource.h
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kSettingDataSourceName = @"kMeDataSourceName";
static NSString *kSettingDataSourceTitle = @"kMeDataSourceTitle";

typedef enum {
    SettingType_Logout,
    SettingType_扩展
} SettingType;


@interface SettingDataSource : NSObject
+ (NSArray *)settingDataSource;
@end
