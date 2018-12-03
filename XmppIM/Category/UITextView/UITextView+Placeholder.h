//
//  @fileName  UITextView+Placeholder.h
//  @abstract  UITextView加Placeholder
//  @author    李宪 创建于 2017/5/10.
//  @revise    李宪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UITextView (Placeholder)

/**
 label
 */
@property (nonatomic, readonly) UILabel *placeholderLabel;

/**
 文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 富文本
 */
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

/**
 颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;


/**
 默认颜色

 @return UIColor
 */
+ (UIColor *)defaultPlaceholderColor;

@end
