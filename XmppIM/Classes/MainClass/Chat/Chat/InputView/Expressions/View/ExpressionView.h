//
//  ExpressionView.h
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionConfig.h"

@class ExpressionView;


@protocol ExpressionViewDelegate <NSObject>
// emoji
- (void)expressionView:(ExpressionView *)expressionView didSelectImageName:(NSString *)imageName;
// 删除
- (void)expressionViewDidSelectDeleteButton:(ExpressionView *)expressionView;
// 发送
- (void)expressionViewDidSelectSendButton:(ExpressionView *)expressionView;
@end


@interface ExpressionView : UIView
+ (instancetype)expressionView;
@property (weak, nonatomic) id<ExpressionViewDelegate> delegate;

/**
 *  设置发送按钮状态
 *  @param enabled 发送按钮是否可点
 */
- (void)setSendButtonState:(BOOL)enabled;

@end
