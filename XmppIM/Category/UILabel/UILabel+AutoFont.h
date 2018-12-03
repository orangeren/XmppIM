//
//  UILabel+AutoFont.h
//  iValet
//
//  Created by 任 on 2018/7/3.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE  //动态刷新

@interface UILabel (AutoFont)
/**
 * 适配字体大小
 */
@property (nonatomic, assign) IBInspectable CGFloat autoFontSize;

@end
