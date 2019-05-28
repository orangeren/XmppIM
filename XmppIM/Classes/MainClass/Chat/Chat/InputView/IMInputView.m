//
//  IMInputView.m
//  XmppWeChat
//
//  Created by 任芳 on 2018/11/4.
//  Copyright © 2018年 任芳. All rights reserved.
//

#import "IMInputView.h"
#import "ICVoiceHud.h"

@interface IMInputView()<
ExpressionTextViewDelegate,     //输入框代理
ExpressionViewDelegate,         //表情键盘代理
AddMoreViewDelegate             //添加更多代理
>
@property (assign, nonatomic) CGFloat keyboardHeight; //键盘高度

// 录音
@property (nonatomic, copy) NSString *recordName; //录音文件名
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ICVoiceHud *voiceHud;

@end

@implementation IMInputView
+ (IMInputView *)inputView {
    return [[NSBundle mainBundle] loadNibNamed:@"IMInputView" owner:self options:nil].firstObject;
}

#pragma mark - lazy load
- (ExpressionView *)emojiView {
    if (!_emojiView) {
        _emojiView = [ExpressionView expressionView];
        _emojiView.frame = CGRectMake(0, ScreenHeight-StatusBarHeight-IMInputView_Height, ScreenWidth, Input_EmojiKeyboard_Height);
        //_emojiView.delegate = self;
    }
    return _emojiView;
}
- (AddMoreView *)addMoreView {
    if (!_addMoreView) {
        _addMoreView = [AddMoreView addMoreView];
        _addMoreView.frame = CGRectMake(0, ScreenHeight-StatusBarHeight-IMInputView_Height, ScreenWidth, Input_EmojiKeyboard_Height);
        _addMoreView.backgroundColor = [UIColor whiteColor];
        //_addMoreView.delegate = self;
    }
    return _addMoreView;
}


- (void)drawRect:(CGRect)rect {
    /* 初始化一下 */
    self.emojiView.delegate = self;
    self.addMoreView.delegate = self;
    
    /* 监听输入 */
    self.inputTextV.expressionDelegate = self;
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    /* 显示键盘 */
    [center addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.status = ChatInputStatusShowKeyboard;
        
        self.keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        [self setInputUIWithState:ChatInputStatusShowKeyboard];
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewController.view layoutIfNeeded];
        }];
        
        //表格滚动到底部
        if (self.scrollBottomBlock) self.scrollBottomBlock();
    }];
    /* 隐藏键盘 */
    [center addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (self.emojiBtn.selected || self.voiceBtn.selected || self.addMoreBtn.selected) {
            // 以下状态存在先隐藏键盘，后走状态界面
            // ChatInputStatusShowEmoji 或 ChatInputStatusShowVoice 或 ChatInputStatusShowMore
        } else {
            self.status = ChatInputStatusNothing;
            [self setInputUIWithState:ChatInputStatusNothing];
        }
        
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            [self.viewController.view layoutIfNeeded];
        }];
    }];
}


#pragma mark -  点击表情
- (IBAction)emojiBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        self.status = ChatInputStatusShowEmoji;
        [self setInputUIWithState:ChatInputStatusShowEmoji];
    }
    else {
        button.selected = NO;
        self.status = ChatInputStatusShowKeyboard;
        [self setInputUIWithState:ChatInputStatusShowKeyboard];
    }
}


#pragma mark - 点击更多
- (IBAction)addBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        self.status = ChatInputStatusShowMore;
        [self setInputUIWithState:ChatInputStatusShowMore];
    }
    else {
        button.selected = NO;
        self.status = ChatInputStatusShowKeyboard;
        [self setInputUIWithState:ChatInputStatusShowKeyboard];
    }  
}


#pragma mark -  点击语音
- (IBAction)voiceBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        self.status = ChatInputStatusShowVoice;
        [self setInputUIWithState:ChatInputStatusShowVoice];
    }
    else {
        button.selected = NO;
        self.status = ChatInputStatusShowKeyboard;
        [self setInputUIWithState:ChatInputStatusShowKeyboard];
    }
}


#pragma mark - 语音

// 按钮 按下    开始录音
- (IBAction)talkButtonDown:(id)sender {
    self.recordName = [self currentRecordFileName];
    [[RecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {
            // 加了录音权限的判断
        } else {
            [self timerInvalue];
            self.voiceHud.hidden = NO;
            [self timer];
        }
    }];
}

// 按钮内 抬起   结束录音
- (IBAction)talkButtonUpInside:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[RecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:kShortRecord]) {
            // 录音时间太短
            [self voiceRecordSoShort];
            [[RecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {
            // 发送语音消息
            [self sendVoiceMessage:recordPath];
        }
    }];
}

// 按钮外 抬起   取消录音
- (IBAction)talkButtonUpOutside:(id)sender {
    // 1.
    [self timerInvalue];
    self.voiceHud.hidden = YES;
    // 2.
    [[RecordManager shareManager] removeCurrentRecordFile:self.recordName];
}

// 向外移动
- (IBAction)talkButtonDragOutside:(id)sender {
    [_timer setFireDate:[NSDate distantFuture]];
    self.voiceHud.animationImages  = nil;
    self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];
}

// 向里移动
- (IBAction)talkButtonDragInside:(id)sender {
    [_timer setFireDate:[NSDate distantPast]];
    _voiceHud.image = [UIImage imageNamed:@"voice_1"];
}

- (IBAction)talkButtonTouchCancel:(id)sender {
}


/* 生成录音文件名 */
- (NSString *)currentRecordFileName {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}
/* 录音时间太短 */
- (void)voiceRecordSoShort {
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceHud.hidden = YES;
    });
}
/* 发送语音消息 */
- (void)sendVoiceMessage:(NSString *)recordPath {
    [self timerInvalue];
    self.voiceHud.hidden = YES;
    if (recordPath) {
        NSLog(@"recordPath - %@",recordPath);
        NSData *data = [NSData dataWithContentsOfFile:recordPath];
        [self sendMsgWithText:@"[语音]" orWithData:data chatType:MessageTypeVoice];
    }
}
/* 录音懒加载 */
- (ICVoiceHud *)voiceHud {
    if (!_voiceHud) {
        _voiceHud = [[ICVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.superVC.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }
    return _voiceHud;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)progressChange {
    AVAudioRecorder *recorder = [[RecordManager shareManager] recorder];
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    self.voiceHud.progress = progress;
}
/* 销毁定时器 */
- (void)timerInvalue {
    [_timer invalidate];
    _timer  = nil;
}


#pragma mark - 输入框 键盘状态
- (void)setInputUIWithState:(ChatInputStatus)status {
    switch (status) {
        case ChatInputStatusNothing: { /* 默认 */
            self.inputButtomViewCons.constant = TabBarHeightAddition;
            self.emojiBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            self.voiceBtn.selected = NO;
            self.inputTextV.hidden = NO;
            self.talkButton.hidden = YES;
            
            [self.inputTextV resignFirstResponder]; // 1.收起键盘
            [self hideEmojiPane];                   // 2.收起表情
            [self hideAddMorePane];                 // 3.收起“更多”
        }
            break;
            
            
        case ChatInputStatusShowKeyboard: { /* 显示键盘 */
            self.inputButtomViewCons.constant = self.keyboardHeight;
            self.emojiBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            self.voiceBtn.selected = NO;
            self.inputTextV.hidden = NO;
            self.talkButton.hidden = YES;
            
            [self.inputTextV becomeFirstResponder]; // 1.显示键盘
            [self hideEmojiPane];                   // 2.收起表情
            [self hideAddMorePane];                 // 3.收起“更多”
        }
            break;
            
            
        case ChatInputStatusShowEmoji: { /* 显示表情 */
            self.emojiBtn.selected = YES;
            self.addMoreBtn.selected = NO;
            self.voiceBtn.selected = NO;
            self.inputTextV.hidden = NO;
            self.talkButton.hidden = YES;
            
            [self.inputTextV resignFirstResponder]; // 1. 收起键盘
            [self hideAddMorePane];                 // 2. 收起“更多”
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{       // 3. 0.1s后添加emoji面板
                [self.superVC.view addSubview:self.emojiView];
                self.inputButtomViewCons.constant = Input_EmojiKeyboard_Height+TabBarHeightAddition;
                [UIView animateWithDuration:0.3 animations:^{
                    self.emojiView.frame = CGRectMake(0, ScreenHeight-Input_EmojiKeyboard_Height-StatusBarHeight-TabBarHeightAddition-IMInputView_Height, ScreenWidth, Input_EmojiKeyboard_Height);
                    [self.viewController.view layoutIfNeeded];
                }];
                //表格滚动到底部
                if (self.scrollBottomBlock) self.scrollBottomBlock();
            });
        }
            break;
            
            
        case ChatInputStatusShowMore: { /* 显示“更多” */
            self.addMoreBtn.selected = YES;
            self.emojiBtn.selected = NO;
            self.voiceBtn.selected = NO;
            self.inputTextV.hidden = NO;
            self.talkButton.hidden = YES;
            
            [self.inputTextV resignFirstResponder]; // 1. 收起键盘
            [self hideEmojiPane];                   // 2. 收起表情
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{       // 3. 0.1s后添加“更多”面板
                [self.superVC.view addSubview:self.addMoreView];
                self.inputButtomViewCons.constant = Input_AddMoreKeyboard_Height+TabBarHeightAddition;
                [UIView animateWithDuration:0.3 animations:^{
                    self.addMoreView.frame = CGRectMake(0, ScreenHeight-Input_AddMoreKeyboard_Height-StatusBarHeight-TabBarHeightAddition-IMInputView_Height, ScreenWidth, Input_AddMoreKeyboard_Height);
                    [self.viewController.view layoutIfNeeded];
                }];
                //表格滚动到底部
                if (self.scrollBottomBlock) self.scrollBottomBlock();
            });
        }
            break;
            
            
        case ChatInputStatusShowVoice: { /* 显示语音 */
            self.inputButtomViewCons.constant = TabBarHeightAddition;
            self.voiceBtn.selected = YES;
            self.inputTextV.hidden = YES;
            self.talkButton.hidden = NO;
            self.emojiBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            
            [self.inputTextV resignFirstResponder]; // 1.收起键盘
            [self hideEmojiPane];                   // 2.收起表情
            [self hideAddMorePane];                 // 3.收起“更多”
        }
            break;
            
        default: break;
    }
}
//收起表情
- (void)hideEmojiPane {
    if ([self.emojiView superview]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.emojiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, Input_EmojiKeyboard_Height);
            [self.viewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.emojiView removeFromSuperview];
        }];
    }
}
//收起"更多"
- (void)hideAddMorePane {
    if ([self.addMoreView superview]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.addMoreView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, Input_AddMoreKeyboard_Height);
            [self.viewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.addMoreView removeFromSuperview];
        }];
    }
}




#pragma mark - ExpressionTextViewDelegate  监听输入框内的文本变化
// 输入框文本发生变化
- (void)expressionTextDidChange:(ExpressionTextView *)textView textLength:(NSInteger)length {
    NSLog(@"文本内容：%@", textView.attributedText);
    
    // 1. emoji面板的发送按钮是否可点击
    [self.emojiView setSendButtonState:length == 0 ? NO : YES];
    
    // 2. 动态设置输入框的高度
    CGFloat contentH = textView.contentSize.height;
    if (contentH > 33 && contentH < 68) { //高度三行内
        self.inputViewHeiCons.constant = contentH + 18;
    }
    
    // 3. 换行就等于点击了Send
    NSString *text = textView.text;
    if ([text rangeOfString:@"\n"].length != 0) {
        text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除换行字符
        textView.text = text;
        
        // 发送
        [self sendMsg];
    }
}

#pragma mark - ExpressionViewDelegate 表情面板 代理
// 表情 - 选择表情
- (void)expressionView:(ExpressionView *)expressionView didSelectImageName:(NSString *)imageName {
    // 在当前位置插入一个表情，更新 .attributedText
    [self.inputTextV setExpressionWithImageName:imageName fontSize:self.inputTextV.defaultFontSize];
}

// 表情 - 删除
- (void)expressionViewDidSelectDeleteButton:(ExpressionView *)expressionView {
    if (self.inputTextV.text.length == 0) {
        return;
    }
    NSMutableAttributedString *originalStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextV.attributedText];
    [originalStr deleteCharactersInRange:NSMakeRange(originalStr.length - 1, 1)];
    self.inputTextV.attributedText = originalStr;
    
    [self.inputTextV textChanged];
}

// 表情 - 发送
- (void)expressionViewDidSelectSendButton:(ExpressionView *)expressionView {
    [self sendMsg];
}


#pragma mark - 发送 [1.键盘发送  2.表情键盘发送]
- (void)sendMsg {
    // 1. 将富文本转化为普通文本
    NSString *normalStr = [ExpresstionTools parseAttributeTextToNormalString:self.inputTextV.attributedText];
    
    // 发送消息
    //[self sendMsgWithText:text chatType:MessageTypeText];//普通文本
    [self sendMsgWithText:normalStr orWithData:nil chatType:MessageTypeText];//表情+文本
    
    // 清空数据
    self.inputTextV.text = nil;
    
    // 发送完消息，将inputView的高度改回来
    self.inputViewHeiCons.constant = 50;
}



#pragma mark - AddMoreViewDelegate
// 发送图片（一张)
- (void)sendImageWithData:(NSData *)imageData bodyMsg:(NSString *)bodyMsg {
    [self sendMsgWithText:bodyMsg orWithData:imageData chatType:MessageTypeImage];
}
// 发送图片（数组）
- (void)sendImages:(NSArray<NSData *> *)imageDataArr bodyMsg:(NSString *)bodyMsg {
    for (NSData *imgData in imageDataArr) {
        [self sendMsgWithText:bodyMsg orWithData:imgData chatType:MessageTypeImage];
    }
}





#pragma mark ------------------------------------------------------
#pragma mark - [发送] - 发送消息给服务器
- (void)sendMsgWithText:(NSString *)text orWithData:(NSData *)data chatType:(NSString *)chatType {
    /*
     <message type="chat" to="zhangsan@renfang.local" chatType="vedio">
     <body>The</body>
     <attachment>base64str</attachment>
     </message>
     */
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    // 1.message 下面添加一个属性：chatType
    [message addAttributeWithName:@"chatType" stringValue:chatType];
    [message addBody:text];
    
    // 2.添加一个子节点：
    if (data) {
        NSString *base64str = [data base64EncodedStringWithOptions:0];
        XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
        [message addChild:attachment];
    }
    
    [kXmppManager.xmppStream sendElement:message];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
