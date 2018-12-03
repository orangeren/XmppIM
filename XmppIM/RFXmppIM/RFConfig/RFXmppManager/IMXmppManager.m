//
//  IMXmppManager.m
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"
#import "IMXmppManager+AutoPing.h"
#import "IMXmppManager+Reconnect.h"
#import "IMXmppManager+Message.h"
#import "IMXmppManager+Roster.h"
#import "IMXmppManager+vCardAvatar.h"

#import "LoginViewController.h"


@interface IMXmppManager()<XMPPStreamDelegate> {
    XMPPConnectBlock _connectBlock;
}
@end

@implementation IMXmppManager

+ (instancetype)sharedManager {
    static IMXmppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMXmppManager alloc] init];
    });
    return manager;
}


- (XMPPStream *)xmppStream {
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        /* 主机名 */
        _xmppStream.hostName = IP;
        /* 主机端口 */
        _xmppStream.hostPort = 5222;
        /* 设置代理 */
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        /* 添加心跳包模块 */
        [self addAutoPingModule];

        /* 添加自动重连模块 */
        [self addReconnectModule];

        /* 添加个人资料模块 */
        [self addVCardAvatarModule];
        
        /* 添加花名册模块 */
        [self addRosterModule];

        /* 添加发消息模块 */
        [self addMessageArchivingModule];
    }
    return _xmppStream;
}
- (void)dealloc {
//    [self removeVCardAvatarModule];
    
    
    [self.xmppStream removeDelegate:self];  // 移除代理
    [self.xmppStream disconnect];           // 断开连接
    self.xmppStream = nil;                  // 清空资源
}

#pragma mark - 用户注册
- (void)xmppUserRegister:(XMPPConnectBlock)connectBlock {
    _connectBlock = connectBlock;
    
    [self.xmppStream disconnect];
    [self connectToHost];
}

#pragma mark - 用户登录
- (void)xmppUserLogin:(XMPPConnectBlock)connectBlock {
    _connectBlock = connectBlock;
    
    [self.xmppStream disconnect];
    [self connectToHost];
}

#pragma mark - 注销
- (void)xmppLogout {
    // 1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:offline];
    
    // 2.与服务器断开连接
    [self.xmppStream disconnect];
    
    // 3.回到登录界面
    [UIApplication sharedApplication].keyWindow.rootViewController = [LoginViewController new];
    
    // 4.更新用户的登录状态
    [IMUserInfo sharedIMUserInfo].loginStatus = NO;
    [[IMUserInfo sharedIMUserInfo] saveUserInfoToSanbox];
}



#pragma mark ------------------------------------------------
#pragma mark - 私有方法
// 连接到服务器
- (void)connectToHost {
    // 发送通知【正在连接】
    [self postConnectStatusNotification:XMPPResultTypeConnecting];
    
    //从单例中获取用户名
    NSString *user = nil;
    if (kXmppManager.isRegisterOperation) {
        user = [IMUserInfo sharedIMUserInfo].registerUser;
    } else {
        user = [IMUserInfo sharedIMUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:Domain resource:@"iphone"];
    self.xmppStream.myJID = myJID;
    self.xmppStream.hostName = IP;
    //self.xmppStream.hostPort = 5222;
    
    // 连接服务器
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        NSLog(@"%@",err);
    }
}


// 通知登录状态
- (void)postConnectStatusNotification:(XMPPResultType)rusultType {
    NSDictionary *userInfo = @{@"loginStatus" : @(rusultType)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectStatusChangeNoti object:nil userInfo:userInfo];
}



#pragma mark - XMPPStreamDelegate 代理
/****************** -------- 与主机连接成功 -------- ******************/
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"loginStep2.与主机连接成功");
    
    if (kXmppManager.registerOperation) {
        [self sendRegisterPswToHost];
    } else {
        [self sendPwdToHost];
    }
}
- (void)sendRegisterPswToHost {
    NSError *err = nil;
    NSString *pasw = [IMUserInfo sharedIMUserInfo].registerPwd;
    [self.xmppStream registerWithPassword:pasw error:&err];
    if (err) {
        [self.xmppStream disconnect];
    }
}
- (void)sendPwdToHost {
    NSError *err = nil;
    NSString *pasw = [IMUserInfo sharedIMUserInfo].pwd;
    [self.xmppStream authenticateWithPassword:pasw error:&err];
    if (err) {
        [self.xmppStream disconnect];
    }
}

/****************** -------- 与主机连接失败 -------- ******************/
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    // 如果有错误，代表连接失败
    // 如果没有错误，表示正常的断开连接（人为断开）
    NSLog(@"与主机断开连接 %@", error);
    
    if(error && _connectBlock) {
        _connectBlock(XMPPResultTypeNetErr);
    }
    
    if (error) { // 发送通知【网络不稳定】
        [self postConnectStatusNotification:XMPPResultTypeNetErr];
    }
}

/****************** -------- 向服务器验证账号成功 -------- ******************/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"验证账号成功");
    
    XMPPPresence *presence = [XMPPPresence presence];
    //NSLog(@"presence - %@",presence);
    [self.xmppStream sendElement:presence];
    
    if (_connectBlock) {
        _connectBlock(XMPPResultTypeLoginSuccess);
    }
    [self postConnectStatusNotification:XMPPResultTypeLoginSuccess];
}

/****************** -------- 向服务器验证账号失败 -------- ******************/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"授权失败 %@",error);
    
    if (_connectBlock) {
        _connectBlock(XMPPResultTypeLoginFailure);
    }
    [self postConnectStatusNotification:XMPPResultTypeLoginFailure];
}

/****************** -------- 注册成功 -------- ******************/
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
    
    if (_connectBlock) {
        _connectBlock(XMPPResultTypeRegisterSuccess);
    }
}

/****************** -------- 注册失败 -------- ******************/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    NSLog(@"注册失败 %@",error);
    
    if (_connectBlock) {
        _connectBlock(XMPPResultTypeRegisterFailure);
    }
}

/****************** -------- 接收消息成功 -------- ******************/
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    //    NSLog(@"收到Message：%@",message);
    if ([message isChatMessageWithBody]) //message
    {
        //        NSLog(@"收到Message-body：%@",message.body);
        
        //        XMPPUserCoreDataStorageObject *friend = [_rosterStorage userForJID:[message from] xmppStream:self.xmppStream managedObjectContext:_rosterStorage.mainThreadManagedObjectContext];
        //        NSString *body = [[message elementForName:@"body"] stringValue];
        //        NSString *displayName = [friend displayName];
        
        
        // 如果当前程序在后台，就发送本地通知
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
            // 本地通知
            UILocalNotification *localNoti = [[UILocalNotification alloc] init];
            // 设置内容
            localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.from.user,message.body];
            // 通知执行的时间
            localNoti.fireDate = [NSDate date];
            // 声音
            localNoti.soundName = @"default";
            // 执行
            [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        }
        // 应用在前台
        else {
            
        }
        
        
        // 向「消息」发送通知 「更新未读数」
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ReceiveMessage object:message];
        
        
        //        // 音视频
        //        NSString *attachment = [[message elementForName:@"attachment"] stringValue];
        //        NSData *data = [attachment dataUsingEncoding:NSUTF8StringEncoding];
        //        if (data.length > 0) {
        //            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //            //    NSLog(@"dict - %@",dict);
        //            if ([dict objectForKey:@"roomId"]) {
        //                //        NSLog(@"roomId:%@",[dict objectForKey:@"roomId"]);
        //                //        [[WebRTCClient sharedInstance] showRTCViewByRemoteName:message.from.full isVideo:YES isCaller:NO];
        //            } else if ([dict objectForKey:@"sdp"] || dict[@"type"]){
        //                [WebRTCClient sharedInstance].myJID = self.xmppStream.myJID.full;
        //                [WebRTCClient sharedInstance].remoteJID = message.from.full;
        //                NSString *chatType = [message attributeStringValueForName:@"chatType"];
        //                [WebRTCClient sharedInstance].isVideo = [chatType isEqualToString:MessageTypeVedio] ? YES : NO;
        //                [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSinalingMessageNotification object:dict];
        //            }
        //        }
    }
}

/****************** -------- 好友连线状态更新 -------- ******************/
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    // NSLog(@"「好友状态」Presence：%@",presence);
    // XMPPPresence 接收好友 在线 离线
    // presence.from 消息是谁发送过来的
}

@end
