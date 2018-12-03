//
//  IMAppCache.h
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAppCache : NSObject
singleton_interface(IMAppCache);


//////////////////// 未读数 ////////////////////
//保存 未读数
+(void)saveUnreadNumToSanbox:(NSMutableDictionary *)dict;
//获取 未读数
+(NSDictionary *)getUnreadNumFromSanbox;
//计算未读消息 总数
+(int)allUnreadNum;


@end
