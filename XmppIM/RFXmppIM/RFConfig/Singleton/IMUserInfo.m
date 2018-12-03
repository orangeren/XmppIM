//
//  IMUserInfo.m
//  XmppIM
//
//  Created by 任 on 2018/9/28.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMUserInfo.h"

#define IMUserKey           @"IMUserKey"
#define IMPwdKey            @"IMPwdKey"
#define IMLoginStatusKey    @"IMLoginStatusKey"


@implementation IMUserInfo

singleton_implementation(IMUserInfo);

- (NSString *)jid {
    return [NSString stringWithFormat:@"%@@%@",self.user, Domain];
}


- (void)saveUserInfoToSanbox {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:IMUserKey];
    [defaults setObject:self.pwd forKey:IMPwdKey];
    [defaults setBool:self.loginStatus forKey:IMLoginStatusKey];
    [defaults synchronize];
}

- (void)loadUserInfoFromSanbox {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:IMUserKey];
    self.pwd = [defaults objectForKey:IMPwdKey];
    self.loginStatus = [defaults boolForKey:IMLoginStatusKey];
}

@end
