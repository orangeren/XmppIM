//
//  IMXmppManager+Roster.m
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager+Roster.h"

@implementation IMXmppManager (Roster)

- (void)addRosterModule {
    // 初始化
    self.rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    self.roster = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage dispatchQueue:dispatch_get_main_queue()];
    
    /* 配置属性 */
    // 1.自动查询花名册
    self.roster.autoFetchRoster = YES;
    // 2.自动接收别人添加好友的请求
    self.roster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // 设置代理
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 激活
    [self.roster activate:self.xmppStream];
}

- (void)removeRosterModule {
    // 移除代理
    [self.roster removeDelegate:self];
    // 停止模块
    [self.roster deactivate];
    // 清空资源
    self.roster = nil;
}



#pragma mark - 花名册 XMPPRosterDelegate 的委托方法:

/* 开始获取花名册 */
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender withVersion:(NSString *)version {
    
}
/* 结束获取花名册 */
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender {
    
}

/* 接收到好友请求

     presence.type有以下几种状态：
     available      : 表示处于在线状态(通知好友在线)
     unavailable    : 表示处于离线状态（通知好友下线）
     subscribe      : 表示发出添加好友的申请（添加好友请求）
     unsubscribe    : 表示发出删除好友的申请（删除好友请求）
     unsubscribed   : 表示拒绝添加对方为好友（拒绝添加对方为好友）
     error          : 表示presence信息报中包含了一个错误消息。（出错）
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    NSLog(@"接收到好友申请消息：%@", [presence fromStr]);
    
    NSString *type = [presence type];// 好友在线状态
    NSString *fromUser = [[presence from] user];// 发送请求者
    NSString *user = self.xmppStream.myJID.user;// 接收者id
    NSLog(@"接收到好友请求状态：%@   发送者：%@  接收者：%@", type, fromUser, user);
    if (![fromUser isEqualToString:user]) {
        if ([type isEqualToString:@"subscribe"]) { // 添加好友
            // 接受添加好友请求
            // 发送type=@"subscribe"表示已经同意添加好友请求并添加到好友花名册中
            //[_roster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:fromUser] andAddToRoster:YES];
            //NSLog(@"已经添加对方为好友，这里就没有弹出让用户选择是否同意，自动同意了");
        } else if ([type isEqualToString:@"unsubscribe"]) { // 请求删除好友
            
        }
    }
}

/* 添加好友同意后，会进入到此代理 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq {
    NSLog(@"添加成功!!!didReceiveRosterPush -> :%@", iq.description);
    
    DDXMLElement *query = [iq elementsForName:@"query"][0];
    DDXMLElement *item = [query elementsForName:@"item"][0];
    
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    // 对方请求添加我为好友且我已同意
    if ([subscription isEqualToString:@"from"]) {// 对方关注我
        NSLog(@"我已同意对方添加我为好友的请求");
    }
    // 我成功添加对方为好友
    else if ([subscription isEqualToString:@"to"]) {// 我关注对方
        NSLog(@"我成功添加对方为好友，即对方已经同意我添加好友的请求");
    }
    // 删除好友
    else if ([subscription isEqualToString:@"remove"]) {
        
    }
}

/* 已经互为好友以后，会回调此
 *
 * Sent when the roster receives a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 *
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item {
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"both"]) {
        NSLog(@"双方已经互为好友");
    }
}


@end
