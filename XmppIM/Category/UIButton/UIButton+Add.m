//
//  UIButton+Add.m
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import "UIButton+Add.h"
#import "UIColor+Add.h"
#import "UIView+Add.h"

@implementation UIButton (Add)

#pragma mark 快速创建纯色按钮
+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = bgColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}

#pragma mark  给按钮设置内容图片  图片按钮 imgName
- (void)setContentImageName:(NSString *)imgName {
    if (imgName) {
        UIImage *img = [UIImage imageNamed:imgName];
        [self setContentImage:img];
    }
}

#pragma mark  给按钮设置内容图片  图片按钮 img
- (void)setContentImage:(UIImage *)img {
    if (img) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        CGSize selfSize = self.frame.size;
        CGSize imgSize = img.size;
        float imgParm_float = imgSize.width / imgSize.height;
        if (selfSize.width < imgSize.width) {
            imgSize.width = selfSize.width;
            imgSize.height = imgSize.width / imgParm_float;
        }
        
        if (selfSize.height < imgSize.height) {
            imgSize.height = selfSize.height;
            imgSize.width = imgSize.height * imgParm_float;
        }
        
        imgView.frame = CGRectMake((selfSize.width - imgSize.width) / 2, (selfSize.height - imgSize.height) / 2, imgSize.width, imgSize.height);
        [self addSubview:imgView];
    }
}

#pragma mark创建确定 重置按钮
+ (UIButton *)creadBtn:(NSString *)titleStr colorStr:(NSString *)colorStr {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor colorWithHexString:colorStr];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    return  btn;
}

@end
