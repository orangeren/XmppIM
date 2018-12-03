//
//  MeInfoDataSource.h
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kMeInfoDataSourceName = @"kMeInfoDataSourceName";
static NSString *kMeInfoDataSourceTitle = @"kMeInfoDataSourceTitle";

typedef enum {
    MeInfoType_HeadPic,
    MeInfoType_NickName,
    MeInfoType_UserName
} MeInfoType;

@interface MeInfoDataSource : NSObject
+ (NSArray *)meInfoDataSource;

@end
