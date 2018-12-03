//
//  IMXmppManager.h
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>

#define kConnectStatusChangeNoti @"kConnectStatusChangeNoti"


#define kXmppManager [IMXmppManager sharedManager]


typedef enum {
    XMPPResultTypeConnecting,       //连接中...
    XMPPResultTypeLoginSuccess,     //登录成功
    XMPPResultTypeLoginFailure,     //登录失败
    XMPPResultTypeNetErr,           //网络不给力
    XMPPResultTypeRegisterSuccess,  //注册成功
    XMPPResultTypeRegisterFailure   //注册失败
} XMPPResultType;

typedef void (^XMPPConnectBlock)(XMPPResultType type);//xmpp请求结果的Block


@interface IMXmppManager : NSObject

+ (instancetype)sharedManager;
@property (strong, nonatomic) XMPPStream *xmppStream;

// 标识「注册」还是「登录」
@property (nonatomic, assign, getter=isRegisterOperation) BOOL registerOperation;

// 用户注册
- (void)xmppUserRegister:(XMPPConnectBlock)connectBlock;
// 用户登录
- (void)xmppUserLogin:(XMPPConnectBlock)connectBlock;
// 注销
- (void)xmppLogout;

@end
