//
//  IMXmppManager+Reconnect.m
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager+Reconnect.h"

@implementation IMXmppManager (Reconnect)

- (void)addReconnectModule {
    /* 1. 初始化 */
    self.xmppReconnect = [[XMPPReconnect alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    
    /* 2. 配置属性 */
    /* 开启自动重连 */
    self.xmppReconnect.autoReconnect = YES;
    /* 设置自动重连延时,表示掉线后,过这么长时间再次请求连接 */
    self.xmppReconnect.reconnectDelay = 5;
    
    /* 3. 激活 */
    [self.xmppReconnect activate:self.xmppStream];
}

- (void)removeReconnectModule {
    // 移除代理
    [self.xmppReconnect removeDelegate:self];
    // 停止模块
    [self.xmppReconnect deactivate];
    // 清空资源
    self.xmppReconnect = nil;
}

@end
