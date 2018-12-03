//
//  ChatTableViewCell.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/17.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ChatTableViewCell : UITableViewCell 
// 必传
@property (nonatomic, strong) XMPPJID *friendJid;
@property (nonatomic, strong) NSNumber *outgoing;
@property (nonatomic, strong) NSDate *timestamp;

// 时间cell
- (void)cellStyleForTime:(NSString *)timeString;

// 文本cell
- (void)cellStyleForText:(NSString *)msgString;

// 图片cell 
- (void)cellStyleForImageWithData:(NSString *)base64str;

// 语音cell
- (void)cellStyleForVoiceWithData:(NSString *)base64str indexRow:(NSInteger)indexRow;

// 音视频cell
- (void)cellStyleForAudioVedio:(NSString *)msgBody;

@end
