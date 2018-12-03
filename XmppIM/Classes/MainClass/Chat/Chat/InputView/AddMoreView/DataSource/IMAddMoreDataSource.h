//
//  IMAddMoreDataSource.h
//  XmppIM
//
//  Created by 任 on 2018/11/9.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kAddMoreDataSourceName = @"kAddMoreDataSourceName";
static NSString *kAddMoreDataSourceIcon = @"kAddMoreDataSourceIcon";
static NSString *kAddMoreDataSourceTitle = @"kAddMoreDataSourceTitle";

typedef enum {
    AddMoreName_Picture,
    AddMoreName_Camera,
    AddMoreName_AudioChat,
    AddMoreName_VideoChat,
    AddMoreName_Location
} AddMoreName;



@interface IMAddMoreDataSource : NSObject

+ (NSArray *)addMoreDataSource;

@end
