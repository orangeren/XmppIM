//
//  LogoutTipsView.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "LogoutTipsView.h"

static CGFloat kTipCellHeight = 60.0f;

@implementation LogoutTipsView

+ (void)tipsTitle:(NSString *)title tipsDesc:(NSString *)desc tipsArr:(NSArray<NSString *> *)tipsArr cancel:(NSString *)cancelStr resultBlock:(BtnClickBlock)btnClickBlock {
    LogoutTipsView *tipsView = [[LogoutTipsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:tipsView];
    
    // 背景
    UIView *shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0;
    [tipsView addSubview:shadowView];
    tipsView.shadowView = shadowView;
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0.5;
    } completion:^(BOOL finished) {}];
    
    // 内容
    [tipsView setUI:tipsView title:title tipsDesc:desc tipsArr:tipsArr cancel:cancelStr];
    
    tipsView.btnClickBlock = btnClickBlock;
}

- (void)setUI:(LogoutTipsView *)tipsView title:(NSString *)title tipsDesc:(NSString *)desc tipsArr:(NSArray<NSString *> *)tipsArr cancel:(NSString *)cancelStr {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tipsView addSubview:contentView];
    tipsView.contentView = contentView;
    
    CGFloat offsetY = 0.0f;
    if (title && title.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, ScreenWidth, kTipCellHeight-1)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor blackColor];
        [contentView addSubview:label];
        
        offsetY += kTipCellHeight;
    }
    if (desc && desc.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, ScreenWidth, kTipCellHeight-1)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = desc;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor lightGrayColor];
        [contentView addSubview:label];
        
        offsetY += kTipCellHeight;
    }
    // 按钮们
    if (tipsArr.count) {
        for (int i=0; i<tipsArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(0, offsetY, ScreenWidth, kTipCellHeight-1);
            [button setTitle:tipsArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [contentView addSubview:button];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside]; 
            
            offsetY += kTipCellHeight;
        }
    }
    if (cancelStr && cancelStr.length) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, 8 + offsetY, ScreenWidth, kTipCellHeight);
        [button setTitle:cancelStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [contentView addSubview:button];
        [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        offsetY += 8 + kTipCellHeight;
    }
    
    
    contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, offsetY);
    [UIView animateWithDuration:0.3 animations:^{
        contentView.y = ScreenHeight - offsetY;
    } completion:^(BOOL finished) {}];
}

// 取消
- (void)cancelAction:(UIButton *)button {
    [self dismiss];
}

// 点击按钮
- (void)btnAction:(UIButton *)button {
    if (self.btnClickBlock) {
        self.btnClickBlock(button.titleLabel.text);
    }
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0;
        self.contentView.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
