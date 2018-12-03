//
//  MeInfoDataSource.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "MeInfoDataSource.h"

@implementation MeInfoDataSource 
+ (NSArray *)meInfoDataSource {
    NSDictionary *headPicDict = @{
                             kMeInfoDataSourceName  : @(MeInfoType_HeadPic),
                             kMeInfoDataSourceTitle  : @"头像"
                             };
    NSDictionary *nickNameDict = @{
                                  kMeInfoDataSourceName  : @(MeInfoType_NickName),
                                  kMeInfoDataSourceTitle : @"昵称"
                                  };
    NSDictionary *userNameDict = @{
                                   kMeInfoDataSourceName  : @(MeInfoType_UserName),
                                   kMeInfoDataSourceTitle : @"用户名"
                                   };
    
    return @[@[headPicDict, nickNameDict, userNameDict]];
}

@end
