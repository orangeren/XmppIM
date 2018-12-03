//
//  AddFriendDataSource.m
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "AddFriendDataSource.h"

@implementation AddFriendDataSource

+ (NSArray *)addFriendDataSource {
    NSDictionary *inputFriendNoDict = @{
                                  kAddFriendDataSourceName  : @(AddFriendName_InputFriendNo),
                                  kAddFriendDataSourceTitle : @"",
                                  kAddFriendDataSourceDesc : @"",
                                  kAddFriendDataSourceIcon : @""
                                  };
    NSDictionary *phoneFriendDict = @{
                                   kAddFriendDataSourceName  : @(AddFriendName_PhoneFriend),
                                   kAddFriendDataSourceTitle : @"手机联系人",
                                   kAddFriendDataSourceDesc : @"添加通讯录中的朋友",
                                   kAddFriendDataSourceIcon : @"Con_addPhone"
                                   };
    
    return @[@[inputFriendNoDict], @[phoneFriendDict]];
}

@end
