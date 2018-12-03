//
//  LogoutTipsView.h
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickBlock)(NSString *btnTitle);

@interface LogoutTipsView : UIView
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) BtnClickBlock btnClickBlock;

+ (void)tipsTitle:(NSString *)title tipsDesc:(NSString *)desc tipsArr:(NSArray<NSString *> *)tipsArr cancel:(NSString *)cancelStr resultBlock:(BtnClickBlock)btnClickBlock;

@end
