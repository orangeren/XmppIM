//
//  IMXmppManager+Message.m
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager+Message.h"

@implementation IMXmppManager (Message)
- (void)addMessageArchivingModule {
    /* 初始化 */
    self.msgStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.msgStorage dispatchQueue:dispatch_get_main_queue()];
    /* 激活 */
    [self.msgArchiving activate:self.xmppStream];
}

- (void)removeMessageArchivingModule {
    // 停止模块
    [self.msgArchiving deactivate];
    // 清空资源
    self.msgArchiving = nil;
}

@end
