//
//  RecordManager.h
//  XmppIM
//
//  Created by 任 on 2018/11/9.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EMVoiceConverter.h"

#define kShortRecord @"kShortRecord"

@interface RecordManager : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) UIImageView *preVoiceIcon;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

+ (id)shareManager;

// 录音结束
@property (nonatomic, copy) void (^voiceDidPlayFinishedBlock)(void);


/*********-------录音----------************/

// 开始录音
- (void)startRecordingWithFileName:(NSString *)fileName
                        completion:(void(^)(NSError *error))completion;
// 结束录音
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 是否拥有权限
- (BOOL)canRecord;

// 取消当前录制
- (void)cancelCurrentRecording;
// 移除音频
- (void)removeCurrentRecordFile:(NSString *)fileName;


/*********-----播放录音--------************/

//- (void)startPlayRecorder:(NSString *)recorderPath;
- (void)startPlayRecorder:(NSData *)data;

- (void)stopPlayRecorder;

- (void)pause;



// 接收到的语音保存路径(文件以fileKey为名字)
- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey;
// 获取语音时长
- (NSUInteger)durationWithVideo:(NSURL *)voiceUrl;

@end
