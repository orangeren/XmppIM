//
//  IMXmppManager+vCardAvatar.m
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager+vCardAvatar.h"

@implementation IMXmppManager (vCardAvatar)

- (void)addVCardAvatarModule {
    /* 添加电子名片模块 */
    self.vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_main_queue()];
    // 2.代理
    [self.vCard addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 3.激活
    [self.vCard activate:self.xmppStream];
    
    /* 添加头像模块 */
    self.avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCard dispatchQueue:dispatch_get_main_queue()];
    // 2.代理
    [self.avatar addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 3.激活
    [self.avatar activate:self.xmppStream];
}

- (void)removeVCardAvatarModule {
    // 移除代理
    [self.vCard removeDelegate:self];
    [self.avatar removeDelegate:self];
    // 停止模块
    [self.vCard deactivate];
    [self.avatar deactivate];
    // 清空资源
    self.vCard = nil;
    self.avatar = nil;
}



#pragma mark - 电子名片 XMPPvCardAvatarDelegate 的委托方法:
/****************** -------- 接收到头像更改(别人的) -------- ******************/
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid {
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceivePhotoNotiKey object:nil];
}



#pragma mark - 电子名片 XMPPvCardTempModuleDelegate 的委托方法:

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid {
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
   failedToFetchvCardForJID:(XMPPJID *)jid
                      error:(NSXMLElement*)error {
    
}

/****************** -------- 电子名片 更新成功 -------- ******************/
- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMyvCardNotiKey object:nil];
    
//    XMPPvCardTemp *vCard = vCardTempModule.myvCardTemp;
//    NSLog(@"vCard -  %@ %@", vCard.nickname, vCard.jid.user);
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error {
    
}


@end
