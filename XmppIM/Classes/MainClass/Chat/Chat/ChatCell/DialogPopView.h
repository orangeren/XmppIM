//
//  DialogPopView.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/8.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DialogPopView : NSObject

// 语音View
@property (nonatomic, strong) UIImageView *voiceIcon;
// 图片View
@property (nonatomic, strong) UIImageView *showImage;

//计算图片高度
- (CGSize)getImageSize:(UIImage *)image;


//泡泡文本
- (UIView *)bubbleView:(NSString *)text fromSelf:(BOOL)fromSelf withPosition:(int)position;

//泡泡图片
- (UIButton *)imageView:(UIImage *)image fromSelf:(BOOL)fromSelf withPosition:(int)position;

//泡泡语音
- (UIButton *)voiceView:(AVAudioPlayer *)audioPlaye fromSelf:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position;

//泡泡语音通话
- (UIButton *)audioView:(NSString *)text fromSelf:(BOOL)fromSelf withPosition:(int)position;

//泡泡视频通话
- (UIButton *)vedioView:(NSString *)text fromSelf:(BOOL)fromSelf withPosition:(int)position;

@end
