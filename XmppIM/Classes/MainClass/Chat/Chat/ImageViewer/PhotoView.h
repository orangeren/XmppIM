//
//  PhotoView.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/29.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDataSource : NSObject

@property (nonatomic, strong) XMPPJID *friendJid;
// 获取数据源
- (NSArray *)loadImageMsgs;
@end


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


@interface PhotoView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;

// 初始化一个图片View
- (void)initPhotoView:(XMPPMessage *)message;

// 获取图片
+ (UIImage *)getImageWithXMPPMessage:(XMPPMessage *)message;
// 缩放图片
+ (CGSize)scaleSize:(CGSize)size;

@end
