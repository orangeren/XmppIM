//
//  UIImageView+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Add)
/**
 *  创建线条
 *
 *  @param frame    大小
 *  @param colorStr 颜色
 *  @param alpha    透明度
 *
 *  @return UIImgaeView
 */
+ (instancetype)initWithFrameForLineImageView:(CGRect)frame Color:(NSString *)colorStr alpha:(float)alpha;

/**
 *  换色
 *
 *  @param colorStr 颜色
 *  @param alpha    透明度
 */
- (void)drawLineWithColor:(NSString *)colorStr alpha:(float)alpha;

@end
