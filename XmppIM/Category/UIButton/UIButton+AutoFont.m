//
//  UIButton+AutoFont.m
//  iValet
//
//  Created by 任 on 2018/7/3.
//  Copyright © 2018年 i代. All rights reserved.
//

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

#import "UIButton+AutoFont.h"

@implementation UIButton (AutoFont)
@dynamic autoFontSize;

/**
 * 设置字体大小
 */
- (void)setAutoFontSize:(CGFloat)autoFontSize {
    if (autoFontSize > 0 ) {
        self.titleLabel.font = [UIFont systemFontOfSize:C_WIDTH(autoFontSize)];
    } else {
        self.titleLabel.font = self.titleLabel.font;
    }
}

@end
