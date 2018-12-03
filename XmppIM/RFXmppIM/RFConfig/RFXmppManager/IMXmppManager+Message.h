//
//  IMXmppManager+Message.h
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"

@interface IMXmppManager ()<XMPPRosterDelegate>
/* 存储聊天数据 */
@property (nonatomic, strong) XMPPMessageArchiving *msgArchiving;
/* 聊天的数据存储 */
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *msgStorage;
@end


@interface IMXmppManager (Message)
- (void)addMessageArchivingModule;
- (void)removeMessageArchivingModule;
@end
