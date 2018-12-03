//
//  IMXmppManager+AutoPing.m
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager+AutoPing.h"

@implementation IMXmppManager (AutoPing)

- (void)addAutoPingModule {
    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [self.xmppAutoPing setPingInterval:1000];
    [self.xmppAutoPing setPingTimeout:2000];
    [self.xmppAutoPing setRespondsToQueries:YES];
    /* 添加代理 */
    [self.xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    /* 激活 */
    [self.xmppAutoPing activate:self.xmppStream];
}

- (void)removeAutoPingModule {
    // 移除代理
    [self.xmppAutoPing removeDelegate:self];
    // 停止模块
    [self.xmppAutoPing deactivate];
    // 清空资源
    self.xmppAutoPing = nil;
}




#pragma mark - XMPPAutoPingDelegate 代理

- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender {
    NSLog(@"发送心跳包成功");
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender {
    NSLog(@"接收到心跳包成功");
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    NSLog(@"请求超时");
}

@end
