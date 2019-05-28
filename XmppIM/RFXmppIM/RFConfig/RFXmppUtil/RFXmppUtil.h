//
//  RFXmppUtil.h
//  XmppIM
//
//  Created by 任 on 2018/9/28.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFXmppUtil : NSObject

#define ScreenWidth             [UIScreen mainScreen].bounds.size.width
#define ScreenHeight            [UIScreen mainScreen].bounds.size.height

#define StatusBarHeight         [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarHeight     StatusBarHeight + 44
#define TabBarHeight            (StatusBarHeight > 21.0 ? 83.0 : 49.0)
#define TabBarHeightAddition    (StatusBarHeight > 21.0 ? 34.0 : 0.0)

#define AdaptedWidth(x)         ceilf((x) * (ScreenWidth / 375.0))
#define AdaptedHeight(x)        ceilf((x) * (ScreenHeight / 667.0))


// 主题色
#define COLOR_Main_STR          @"FFFFFF"
// 背景颜色
#define COLOR_Background_STR    @"f2f4f5"



#pragma mark - --------------------------------------------
// 定义通知key
#define Notification_ToTabIndex0 @"Notification_ToTabIndex0"
#define Notification_ReceiveMessage @"Notification_ReceiveMessage"
#define ReceivedSinalingMessageNotification @"ReceivedSinalingMessageNotification"
#define CallStatusChangeNotification @"CallStatusChangeNotification"




#pragma mark - --------------------------------------------
// 录音文件
#define kRecoderType @".wav"
#define kRecodAmrType @".amr"
#define kChatRecoderPath @"Chat/Recoder"

// 消息类型 chatType
#define MessageTypeText @"text"         //文本
#define MessageTypeImage @"image"       //图片
#define MessageTypeVoice @"voice"       //语音
#define MessageTypeAudio @"audioChat"   //音频通话
#define MessageTypeVedio @"vedioChat"   //视频通话



#pragma mark - --------------------------------------------
// 键盘状态
typedef NS_ENUM (NSInteger, ChatInputStatus) {
    ChatInputStatusNothing,         // 默认状态
    ChatInputStatusShowKeyboard,    // 正常键盘
    ChatInputStatusShowEmoji,       // 输入表情状态
    ChatInputStatusShowVoice,       // 录音状态
    ChatInputStatusShowMore,        // 显示“更多”页面状态
    ChatInputStatusShowVideo        // 录制视频
};
// 对话状态
typedef NS_ENUM (NSInteger, CallStatus) {
    CallStatusOffline,              //对方不在线
    CallStatusCalling,              //正在通话中
    CallStatusWaitingForAnswer,     //等待对方接听
    CallStatusEnd,                  //结束通话
    CallStatusRefused,              //对方已拒绝
    CallStatusCancel,               //取消通话
    CallStatusRefusedForAnswer      //拒绝接听
};


@end
