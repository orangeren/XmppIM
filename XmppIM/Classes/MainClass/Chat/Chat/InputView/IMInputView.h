//
//  IMInputView.h
//  XmppWeChat
//
//  Created by 任芳 on 2018/11/4.
//  Copyright © 2018年 任芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputConfig.h"
#import "ExpressionTextView.h"
#import "RecordManager.h"

#import "AddMoreView.h"
#import "ExpressionView.h"



#define IMInputView_Height 50

@interface IMInputView : UIView
+ (IMInputView *)inputView;

/** 保存状态 */
@property (nonatomic, assign) ChatInputStatus status;// 键盘状态

/** 传值（必传） */
@property (nonatomic, strong) XMPPJID *friendJid;
@property (strong, nonatomic) NSLayoutConstraint *inputButtomViewCons;//inputView 底部约束
@property (strong, nonatomic) NSLayoutConstraint *inputViewHeiCons;   //inputView 高度约束
@property (nonatomic, strong) UIViewController *superVC;

@property (strong, nonatomic) ExpressionView *emojiView;    //表情
@property (strong, nonatomic) AddMoreView *addMoreView;     //更多

@property (weak, nonatomic) IBOutlet ExpressionTextView *inputTextV; 
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;
@property (weak, nonatomic) IBOutlet UIButton *addMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;

/** 输入框 键盘状态 */
- (void)setInputUIWithState:(ChatInputStatus)status;
/** table滑到底部 */
@property (nonatomic, copy) void (^scrollBottomBlock)(void); 
@end
