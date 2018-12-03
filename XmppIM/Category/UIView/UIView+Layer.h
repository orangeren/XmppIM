//
//  UIView+Layer.h
//  iValetNew
//
//  Created by 任 on 2017/12/11.
//  Copyright © 2017年 RYX. All rights reserved.
//
//  UIView 圆角

#import <UIKit/UIKit.h>

/**
 * 这个宏定义的作用是可以通过keypath动态看到效果,实时性,不过还是需要通过在keypath中输入相关属性来设置
 */
IB_DESIGNABLE  //动态刷新

@interface UIView (Layer)

/**
 * 可视化设置边框宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 * 可视化设置边框颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 * 可视化设置圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
