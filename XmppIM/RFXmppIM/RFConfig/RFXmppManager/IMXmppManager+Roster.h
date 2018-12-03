//
//  IMXmppManager+Roster.h
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"


@interface IMXmppManager ()<XMPPRosterDelegate>
/* 花名册模块 */
@property (strong, nonatomic) XMPPRoster *roster;
/* 花名册数据存储 */
@property (strong, nonatomic) XMPPRosterCoreDataStorage *rosterStorage;
@end


@interface IMXmppManager (Roster)
- (void)addRosterModule;
- (void)removeRosterModule;
@end

