//
//  MeDataSource.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "MeDataSource.h"

@implementation MeDataSource

+ (NSArray *)meDataSource {
    NSDictionary *meDict = @{
                             kMeDataSourceName  : @(MeType_Me),
                             kMeDataSourceIcon  : @"",
                             kMeDataSourceTitle : @""
                             };
    NSDictionary *settingDict = @{
                             kMeDataSourceName  : @(MeType_Setting),
                             kMeDataSourceIcon  : @"MeSetting",
                             kMeDataSourceTitle : @"设置"
                             };
    
    return @[@[meDict], @[settingDict]];
}

@end
