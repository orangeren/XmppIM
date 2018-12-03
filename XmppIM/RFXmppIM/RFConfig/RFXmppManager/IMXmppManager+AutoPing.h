//
//  IMXmppManager+AutoPing.h
//  XmppIM
//
//  Created by 任 on 2018/11/1.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMXmppManager.h"
#import <XMPPFramework/XMPPAutoPing.h>

@interface IMXmppManager ()<XMPPAutoPingDelegate>
@property (nonatomic,strong)XMPPAutoPing *xmppAutoPing;
@end


@interface IMXmppManager (AutoPing)
- (void)addAutoPingModule;
- (void)removeAutoPingModule;
@end
