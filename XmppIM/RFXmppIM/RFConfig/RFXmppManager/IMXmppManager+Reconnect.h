//
//  IMXmppManager+Reconnect.h
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"
#import "XMPPReconnect.h"

@interface IMXmppManager ()<XMPPAutoPingDelegate>
/* 自动连接模块 */ 
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;
@end

@interface IMXmppManager (Reconnect)
- (void)addReconnectModule;
- (void)removeReconnectModule;
@end
