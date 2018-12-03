//
//  IMXmppManager+vCardAvatar.h
//  XmppIM
//
//  Created by 任 on 2018/11/2.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"

@interface IMXmppManager ()
/* 电子名片模块 */
@property (strong, nonatomic) XMPPvCardTempModule *vCard;
/* 头像模块 */
@property (strong, nonatomic) XMPPvCardAvatarModule *avatar;
@end


@interface IMXmppManager (vCardAvatar)<XMPPvCardAvatarDelegate, XMPPvCardTempModuleDelegate>
- (void)addVCardAvatarModule;
- (void)removeVCardAvatarModule;
@end
