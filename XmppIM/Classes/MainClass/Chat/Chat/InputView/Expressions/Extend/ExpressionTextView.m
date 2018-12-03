//
//  ExpressionTextView.m
//  XmppIM
//
//  Created by 任 on 2018/11/9.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ExpressionTextView.h"
#import "ExpressionConfig.h"

@interface ExpressionTextView ()<UITextViewDelegate>

@end

@implementation ExpressionTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _defaultFontSize = self.font.pointSize;
    self.delegate = self;
}


#pragma mark - 公共方法

// 在当前位置插入一个表情
- (void)setExpressionWithImageName:(NSString *)imageName fontSize:(CGFloat)fontSize {
    //富文本
    ExpressionTextAttachment *attachment = [[ExpressionTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *image = [UIImage imageNamed:imageName];
    attachment.image = image;
    attachment.text = [ExpresstionTools getExpressionNameWithImageName:imageName];
    attachment.bounds = CGRectMake(0, -6, fontSize+10, fontSize+10);
    NSAttributedString *insertAttributeStr = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *resultAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //在当前编辑位置插入字符串
    [resultAttrString insertAttributedString:insertAttributeStr atIndex:self.selectedRange.location];
    self.attributedText = resultAttrString;
    
    NSRange tempRange = self.selectedRange;
    self.selectedRange = NSMakeRange(tempRange.location + 1, 0);
    [self.textStorage addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_defaultFontSize]} range:NSMakeRange(0, self.attributedText.length)];
    [self scrollRangeToVisible:self.selectedRange];
    
    [self textChanged];
}

- (void)textChanged {
    [self textViewDidChange:self];
}


#pragma mark - UITextViewDelegate
// 1.输入文字 2.输入表情  执行
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textView原 - %@",textView.text);
    if ([self.expressionDelegate respondsToSelector:@selector(expressionTextDidChange:textLength:)]) {
        [self.expressionDelegate expressionTextDidChange:self textLength:self.attributedText.length];
    }
}




#pragma mark - Actions
- (void)copy:(id)sender {
    NSAttributedString *selectedStr = [self.attributedText attributedSubstringFromRange:self.selectedRange];
    NSString *copyStr = [ExpresstionTools parseAttributeTextToNormalString:selectedStr];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (copyStr.length != 0) {
        pboard.string = copyStr;
    }
}
- (void)cut:(id)sender {
    [self copy:sender];
    NSMutableAttributedString *originalStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [originalStr deleteCharactersInRange:self.selectedRange];
    self.attributedText = originalStr;
    
    [self textChanged];
}

@end
