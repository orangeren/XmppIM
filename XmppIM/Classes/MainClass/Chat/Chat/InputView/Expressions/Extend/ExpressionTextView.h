//
//  ExpressionTextView.h
//  XmppIM
//
//  Created by 任 on 2018/11/9.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressionTextView;

@protocol ExpressionTextViewDelegate <UITextViewDelegate>
// 富文本发生改变
- (void)expressionTextDidChange:(ExpressionTextView *)textView textLength:(NSInteger)length;
@end


@interface ExpressionTextView : UITextView
@property (nonatomic, weak) id<ExpressionTextViewDelegate> expressionDelegate;

@property (nonatomic, strong) NSString *originalString;//用于粘贴复制的字符串
@property (nonatomic, assign) CGFloat defaultFontSize;

- (void)setExpressionWithImageName:(NSString *)imageName fontSize:(CGFloat)fontSize;
- (void)textChanged;

@end
