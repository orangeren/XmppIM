//
//  DialogPopView.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/8.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "DialogPopView.h"
#import "ExpresstionTools.h"

@implementation DialogPopView

- (CGSize)getImageSize:(UIImage *)image {
    CGSize size = image.size;
    // 高： min ：64
    // 宽： max ：ScreenWidth/2-position
    
    // 计算要显示image的宽高
    float wid = image.size.width;
    float hei = image.size.height;
    if (wid > (ScreenWidth/2-64)) {
        wid = ScreenWidth/2-64;
        hei = image.size.height/image.size.width * wid;
        size = CGSizeMake(wid, hei);
    } else if (hei < 64) {
        hei = 64;
        wid = image.size.width/image.size.height * hei;
        size = CGSizeMake(wid, hei);
    }
    
    return size;
}



//泡泡文本
- (UIView *)bubbleView:(NSString *)msgStr fromSelf:(BOOL)fromSelf withPosition:(int)position{ 
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    if (!msgStr) {
        msgStr = @"...";
    }
    
    // 文本高度
    //CGSize size = [Common getHeightWithString:text setWidth:ScreenWidth-165.0f fontSize:font.pointSize];
    
    /*
    // 富文本高度
    // 1.普通文本 转 富文本
    NSAttributedString *attrStr = [WKExpressionTool generateAttributeStringWithOriginalString:text fontSize:font.pointSize];
    // 2.计算高度
    CGSize size = [attrStr boundingRectWithSize:CGSizeMake(ScreenWidth-165.0f,MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    */
    
    CGSize maxSize = CGSizeMake(ScreenWidth-165.0f,MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [msgStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageNamed:[NSString stringWithFormat:@"%@", fromSelf?@"SenderVoiceBg":@"ReceiverVoiceBg"]];
    
    //图片变形
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/1.5)]];
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 6.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    //bubbleText.text = text;
    bubbleText.attributedText = [ExpresstionTools generateAttributeStringWithOriginalString:msgStr fontSize:14.0f];
    [bubbleImageView addSubview:bubbleText];
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+12.0f);
    
    if(fromSelf) {
        returnView.frame = CGRectMake(ScreenWidth-position-(bubbleImageView.frame.size.width), 0.0f, bubbleImageView.frame.size.width, bubbleImageView.frame.size.height+28.0f);
    } else {
        returnView.frame = CGRectMake(position, 0.0f, bubbleImageView.frame.size.width, bubbleImageView.frame.size.height+28.0f);
    }
    
    [returnView addSubview:bubbleImageView];
    
    return returnView;
}

//泡泡图片
- (UIButton *)imageView:(UIImage *)image fromSelf:(BOOL)fromSelf withPosition:(int)position {
    
    CGSize size = image.size;
    // 高： min ：64
    // 宽： max ：ScreenWidth/2-position
    
    // 计算要显示image的宽高
    float wid = image.size.width;
    float hei = image.size.height;
    if (wid > (ScreenWidth/2-position)) {
        wid = ScreenWidth/2-position;
        hei = image.size.height/image.size.width * wid;
        size = CGSizeMake(wid, hei);
    } else if (hei < 64) {
        hei = 64;
        wid = image.size.width/image.size.height * hei;
        size = CGSizeMake(wid, hei);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(fromSelf) {
        button.frame = CGRectMake(ScreenWidth-position-size.width, 14.0f, size.width, size.height);
    }
    else {
        button.frame = CGRectMake(position, 14.0f, size.width, size.height);
    }
    
    //背景图片
    UIImage *bgImg = [UIImage imageNamed:fromSelf?@"SenderVoiceBg":@"ReceiverVoiceBg"];
    UIImage *bgImage = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width/2) topCapHeight:floorf(bgImg.size.height/1.5)];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    //图片
    _showImage = [[UIImageView alloc] init];
    _showImage.frame = CGRectMake(fromSelf?0:6.5, 0, button.frame.size.width-6.5, button.frame.size.height);
    _showImage.layer.cornerRadius = 5;
    _showImage.layer.masksToBounds = YES;
    _showImage.layer.borderColor = [UIColor colorWithR:18 g:188 b:207].CGColor;
    _showImage.layer.borderWidth = 0.5;
    _showImage.image = image;
    
    
    [button addSubview:_showImage];
    return button;
}

//泡泡语音
- (UIButton *)voiceView:(AVAudioPlayer *)audioPlayer fromSelf:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position {
    
    //根据语音长度
    int voiceLength = (int)audioPlayer.duration;
    int yuyinwidth = (ScreenWidth-(200+66))/20 * (voiceLength<20?voiceLength:20) + 66 +fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf) {
        button.frame = CGRectMake(ScreenWidth-position-yuyinwidth, 12, yuyinwidth, 40);
    }
    else {
        button.frame = CGRectMake(position, 12, yuyinwidth, 40);
    }
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceBg":@"ReceiverVoiceBg"];
    UIImage *backgroundImageH = [UIImage imageNamed:fromSelf?@"SenderVoiceBgH":@"ReceiverVoiceBgH"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    backgroundImageH = [backgroundImageH stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImageH forState:UIControlStateSelected];
    
    // 语音图片
    _voiceIcon = [[UIImageView alloc] init];
    _voiceIcon.frame = CGRectMake(fromSelf?button.frame.size.width-(18*(36/51.0))-15:15, 10, 18*(36/51.0), 18);
    if (fromSelf) {
        self.voiceIcon.image = [UIImage imageNamed:@"right-3"];
        UIImage *image1 = [UIImage imageNamed:@"right-1"];
        UIImage *image2 = [UIImage imageNamed:@"right-2"];
        UIImage *image3 = [UIImage imageNamed:@"right-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    } else {
        self.voiceIcon.image = [UIImage imageNamed:@"left-3"];
        UIImage *image1 = [UIImage imageNamed:@"left-1"];
        UIImage *image2 = [UIImage imageNamed:@"left-2"];
        UIImage *image3 = [UIImage imageNamed:@"left-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    }
    self.voiceIcon.animationDuration = 0.8;
    [button addSubview:_voiceIcon];
    
    // 显示语音时长
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, 40)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%d''",(int)audioPlayer.duration];
    [button addSubview:label]; 
    
    return button;
}


//泡泡语音通话
- (UIButton *)audioView:(NSString *)text fromSelf:(BOOL)fromSelf withPosition:(int)position {
    //长度
    int cellWidth = 150;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(fromSelf) {
        button.frame = CGRectMake(ScreenWidth-position-cellWidth, 12, cellWidth, 40);
    }
    else {
        button.frame = CGRectMake(position, 12, cellWidth, 40);
    }
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceBg":@"ReceiverVoiceBg"];
    UIImage *backgroundImageH = [UIImage imageNamed:fromSelf?@"SenderVoiceBgH":@"ReceiverVoiceBgH"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    backgroundImageH = [backgroundImageH stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImageH forState:UIControlStateSelected];
    
    // 麦克风图片
    UIImageView *audioIcon = [[UIImageView alloc] init];
    audioIcon.frame = CGRectMake(fromSelf?button.frame.size.width-18-15:15, 10, 18, 18);
    if (fromSelf) {
        audioIcon.image = [UIImage imageNamed:@"voiceinput_self"];
    } else {
        audioIcon.image = [UIImage imageNamed:@"voiceinput_other"];
    }
    [button addSubview:audioIcon];
    
    // 显示通话的状态
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf ? 0 : 50, 0, button.frame.size.width-50, button.frame.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    if (fromSelf) {
         label.textAlignment = NSTextAlignmentRight;
    } else {
         label.textAlignment = NSTextAlignmentLeft;
    }
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [button addSubview:label];
    
    return button;
}

//泡泡视频通话
- (UIButton *)vedioView:(NSString *)text fromSelf:(BOOL)fromSelf withPosition:(int)position {
    //长度
    int cellWidth = 150;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(fromSelf) {
        button.frame = CGRectMake(ScreenWidth-position-cellWidth, 12, cellWidth, 40);
    }
    else {
        button.frame = CGRectMake(position, 12, cellWidth, 40);
    }
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceBg":@"ReceiverVoiceBg"];
    UIImage *backgroundImageH = [UIImage imageNamed:fromSelf?@"SenderVoiceBgH":@"ReceiverVoiceBgH"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    backgroundImageH = [backgroundImageH stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImageH forState:UIControlStateSelected];
    
    // 视频图片
    UIImageView *audioIcon = [[UIImageView alloc] init];
    audioIcon.frame = CGRectMake(fromSelf?button.frame.size.width-18-15:15, 10, 18, 18);
    if (fromSelf) {
        audioIcon.image = [UIImage imageNamed:@"videovoip_self"];
    } else {
        audioIcon.image = [UIImage imageNamed:@"videovoip_other"];
    }
    [button addSubview:audioIcon];
    
    // 显示视频的状态 
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf ? 0 : 50, 0, button.frame.size.width-50, button.frame.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    if (fromSelf) {
        label.textAlignment = NSTextAlignmentRight;
    } else {
        label.textAlignment = NSTextAlignmentLeft;
    }
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [button addSubview:label];
    
    return button;
}



@end
