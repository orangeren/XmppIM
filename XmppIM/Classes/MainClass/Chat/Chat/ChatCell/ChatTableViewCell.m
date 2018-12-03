//
//  ChatTableViewCell.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/17.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "XMPPvCardTemp.h"
#import "DialogPopView.h"
#import "UIImageView+WebCache.h"//加载图片
#import "RecordManager.h"
#import "ImagesScrollView.h"

@interface ChatTableViewCell()
@property (nonatomic, strong) DialogPopView *popView;
@property (nonatomic ,strong) NSData *base64data;
@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
} 


#pragma mark - 私有方法
// 自己的头像图片
- (UIImage *)getSelfPhoto {
    XMPPvCardTemp *myVCard = kXmppManager.vCard.myvCardTemp;
    if (myVCard.photo) {
        return [UIImage imageWithData:myVCard.photo];
    }
    return [UIImage imageNamed:@"defaultPhoto"];
}
// 好友的头像图片
- (UIImage *)getFriendPhoto {
    NSData *photoData = [kXmppManager.avatar photoDataForJID:_friendJid];
    if (photoData) {
        return [UIImage imageWithData:photoData];
    }
    return [UIImage imageNamed:@"defaultPhoto"];
}

// 创建头像
- (void)createHeader {
    UIImageView *headPhoto = [[UIImageView alloc] init];
    headPhoto.layer.cornerRadius = 21;
    headPhoto.layer.masksToBounds = YES;
    headPhoto.frame = CGRectMake(_outgoing.intValue==1 ? (ScreenWidth-60):10, 12, 40, 40);
    headPhoto.image = (_outgoing.intValue==1 ? [self getSelfPhoto]:[self getFriendPhoto]);
    [self addSubview:headPhoto];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = headPhoto.frame;
    [headBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headBtn];
}
// 点击头像
- (void)headClick:(UIButton*)button {
    if (_outgoing.intValue==1) {
        NSLog(@"点击了自己的头像");
    } else {
        NSLog(@"点击了朋友的头像");
    }
}


#pragma mark - 共有方法  -- cell 的样式

/* 时间cell */
- (void)cellStyleForTime:(NSString *)timeString {
    CGFloat strWid = [timeString getStringWidth:[UIFont systemFontOfSize:12.0f] height:20];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-strWid)/2, 2, strWid+10, 16)];
    [self addSubview:timeLabel];
    
    timeLabel.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:11.0f];
    timeLabel.cornerRadius = 4;
    timeLabel.text = timeString;
}

/* 文本cell */
- (void)cellStyleForText:(NSString *)msgString { 
    // 1.创建头像
    [self createHeader];
    
    // 2.显示text消息
    if (!self.popView) {
        self.popView = [[DialogPopView alloc] init];
    }
    [self addSubview:[self.popView bubbleView:msgString fromSelf:[_outgoing boolValue] withPosition:65]];
}

/* 图片cell  */
- (void)cellStyleForImageWithData:(NSString *)base64str {
    // 1.创建头像
    [self createHeader];
    
    // 2.取出图片的解码
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
    _base64data = [NSData dataWithData:data];
    UIImage *image = [[UIImage alloc] initWithData:data];
    //self.imageView.image = image; 
    
    // 3.显示图片
    if (!self.popView) {
        self.popView = [[DialogPopView alloc] init];
    }
    UIButton *imageBtn = [self.popView imageView:image fromSelf:[_outgoing boolValue] withPosition:65];
    [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
}
- (void)imageBtnClick:(UIButton *)sender {
    // 点击图片放大显示 
    ImagesScrollView *imageScroll = [[ImagesScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageScroll.friendJid = self.friendJid;
    imageScroll.timestamp = self.timestamp;
    CGRect orginRect = [imageScroll convertRect:self.popView.showImage.frame toView:imageScroll];
    imageScroll.showImageRect = orginRect;
    [[UIApplication sharedApplication].keyWindow addSubview:imageScroll];
}


/* 语音cell */
- (void)cellStyleForVoiceWithData:(NSString *)base64str indexRow:(NSInteger)indexRow {
    // 1.创建头像
    [self createHeader];
    
    // 2.音频解码
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
    
    if (data && data.length > 0) {
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        _base64data = [NSData dataWithData:data];
        
        // 3.显示语音
        if (!self.popView) {
            self.popView = [[DialogPopView alloc] init];
        }
        UIButton *voiceBtn = [self.popView voiceView:audioPlayer fromSelf:[_outgoing boolValue] withIndexRow:indexRow withPosition:65];
        [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceBtn];
    }
}
- (void)voiceBtnClick:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
    
        // 点击播放语音
        RecordManager *manager = [RecordManager shareManager];
        [manager startPlayRecorder:_base64data];
        __weak typeof(self)weakSelf = self;
        manager.voiceDidPlayFinishedBlock = ^{
            [weakSelf.popView.voiceIcon stopAnimating];
            UIButton *button = (UIButton *)[weakSelf.popView.voiceIcon superview];
            button.selected = NO;
        };
        
        [_popView.voiceIcon startAnimating];
        
        // 上一次语音未播放完的话，停止播放，将按钮状态恢复到普通状态
        UIButton *preBtn = (UIButton *)[manager.preVoiceIcon superview];
        if (preBtn != sender) {
            preBtn.selected = NO;
            
            [manager.preVoiceIcon stopAnimating];
            manager.preVoiceIcon = _popView.voiceIcon;
        }
    }
    else {
        sender.selected = NO;
        
        // 再点，停止播放语音
        RecordManager *manager = [RecordManager shareManager];
        [manager stopPlayRecorder];
        
        [_popView.voiceIcon stopAnimating];
    }
}


/* 音视频cell */
- (void)cellStyleForAudioVedio:(NSString *)msgAttachment {
    // 1.创建头像
    [self createHeader];
    
    // 2.显示text消息
    if (!_popView) {
        _popView = [[DialogPopView alloc] init];
    }
    
    NSData *data = [msgAttachment dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    /*
     {
     answered = 0;
     isVideo = 0;
     type = bye;
     }
     */ 
    NSString *showString;
    if ([[dict objectForKey:@"isVideo"] boolValue]) {
        // Video
        if ([[dict objectForKey:@"answered"] boolValue]) {
            showString = @"通话时长：xxx";
        } else {
            showString = [_outgoing boolValue] ? @"已取消":@"对方已取消";
        }
        [self addSubview:[_popView vedioView:showString fromSelf:[_outgoing boolValue] withPosition:65]];
    } else {
        // Audio
        if ([[dict objectForKey:@"answered"] boolValue]) {
            showString = @"通话时长：xxx";
        } else {
            showString = [_outgoing boolValue] ? @"已取消":@"对方已取消";
        }
        
        [self addSubview:[_popView audioView:showString fromSelf:[_outgoing boolValue] withPosition:65]];
    }
}



@end
