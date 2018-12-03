//
//  SettingDataSource.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SettingDataSource.h"

@implementation SettingDataSource

+ (NSArray *)settingDataSource {
    NSDictionary *logoutDict = @{
                             kSettingDataSourceName  : @(SettingType_Logout),
                             kSettingDataSourceTitle  : @"退出登录"
                             }; 
    
    return @[@[logoutDict]];
}

@end
