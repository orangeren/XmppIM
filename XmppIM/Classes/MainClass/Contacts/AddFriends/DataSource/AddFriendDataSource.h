//
//  AddFriendDataSource.h
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kAddFriendDataSourceName = @"kAddFriendDataSourceName";
static NSString *kAddFriendDataSourceTitle = @"kAddFriendDataSourceTitle";
static NSString *kAddFriendDataSourceDesc = @"kAddFriendDataSourceDesc";
static NSString *kAddFriendDataSourceIcon = @"kAddFriendDataSourceIcon";

typedef enum {
    AddFriendName_InputFriendNo,    // 手输用户号
    AddFriendName_PhoneFriend       // 手机联系人
} AddFriendName;


@interface AddFriendDataSource : NSObject
+ (NSArray *)addFriendDataSource;

@end
