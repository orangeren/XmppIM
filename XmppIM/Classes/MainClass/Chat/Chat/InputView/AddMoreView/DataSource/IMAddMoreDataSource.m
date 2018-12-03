//
//  IMAddMoreDataSource.m
//  XmppIM
//
//  Created by 任 on 2018/11/9.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "IMAddMoreDataSource.h"

@implementation IMAddMoreDataSource
+ (NSArray *)addMoreDataSource {
    // 图片
    NSDictionary *pictureDic = @{
                                 kAddMoreDataSourceName  : @(AddMoreName_Picture),
                                 kAddMoreDataSourceIcon  : @"sharemore_photo",
                                 kAddMoreDataSourceTitle : @"相册"
                                 };
    // 拍照
    NSDictionary *cameraDic = @{
                                kAddMoreDataSourceName  : @(AddMoreName_Camera),
                                kAddMoreDataSourceIcon  : @"sharemore_camera",
                                kAddMoreDataSourceTitle : @"拍照"
                                };
    // 语音聊天
    NSDictionary *voiceChatDic = @{
                                   kAddMoreDataSourceName  : @(AddMoreName_AudioChat),
                                   kAddMoreDataSourceIcon  : @"sharemore_audio",
                                   kAddMoreDataSourceTitle : @"语音通话"
                                   };
    // 视频聊天
    NSDictionary *videoChatDic = @{
                                   kAddMoreDataSourceName  : @(AddMoreName_VideoChat),
                                   kAddMoreDataSourceIcon  : @"sharemore_vedio",
                                   kAddMoreDataSourceTitle : @"视频通话"
                                   };
    // 定位
    NSDictionary *locationDic = @{
                                 kAddMoreDataSourceName  : @(AddMoreName_Location),
                                 kAddMoreDataSourceIcon  : @"sharemore_定位",
                                 kAddMoreDataSourceTitle : @"定位"
                                 };
    
    return @[pictureDic, cameraDic, voiceChatDic, videoChatDic, locationDic];
}

@end
