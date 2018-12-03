//
//  UILabel+AutoFont.m
//  iValet
//
//  Created by 任 on 2018/7/3.
//  Copyright © 2018年 i代. All rights reserved.
//

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

#import "UILabel+AutoFont.h"

@implementation UILabel (AutoFont)
@dynamic autoFontSize;

/**
 * 设置字体大小
 */
- (void)setAutoFontSize:(CGFloat)autoFontSize {
    if (autoFontSize > 0 ) {
        self.font = [UIFont systemFontOfSize:C_WIDTH(autoFontSize)];
    } else {
        self.font = self.font;
    }
}

@end
