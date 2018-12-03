//
//  IMUserInfo.h
//  XmppIM
//
//  Created by 任 on 2018/9/28.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface IMUserInfo : NSObject
singleton_interface(IMUserInfo);


@property (nonatomic, copy) NSString *user;     //用户名
@property (nonatomic, copy) NSString *pwd;      //密码
@property (nonatomic, assign) BOOL loginStatus; //登录状态

// xmpp连接的状态
@property (nonatomic, assign) int connectStatus;

@property (nonatomic, copy) NSString *registerUser; //注册用户
@property (nonatomic, copy) NSString *registerPwd;  //注册密码
@property (nonatomic, copy) NSString *jid;


//////////////////// 用户数据 ////////////////////
//从沙盒里获取用户数据
- (void)loadUserInfoFromSanbox;
//保存用户数据到沙盒
- (void)saveUserInfoToSanbox;

@end
