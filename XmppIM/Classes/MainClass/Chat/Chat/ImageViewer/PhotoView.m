//
//  PhotoView.m
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/29.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import "PhotoView.h"

@implementation ImageDataSource

// 获取数据源
- (NSArray *)loadImageMsgs {
    NSManagedObjectContext *context = kXmppManager.msgStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 过滤，排序
    //a.1.当前登录用户的JID的消息
    //  2.好友的JID的消息
    //  3.body = [图片]
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@ AND body = %@",[IMUserInfo sharedIMUserInfo].jid,self.friendJid.bare, @"[图片]"];
    request.predicate = pre;
    //b.时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    NSArray *result = [context executeFetchRequest:request error:nil];
    return result;
}

@end



@implementation PhotoView

- (void)initPhotoView:(XMPPMessage *)message {
    self.maximumZoomScale = 3.0;
    self.minimumZoomScale = 1.0;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.multipleTouchEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    // setImage setFrame
    UIImage *tempImage = [PhotoView getImageWithXMPPMessage:message];
    CGSize size = [PhotoView scaleSize:tempImage.size];
    UIImage *newImage = [Common scaleImage:tempImage toSize:size];
    _imageView.image = newImage;
    _imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    _imageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
}

// 图片放大1.5倍
+ (CGSize)scaleSize:(CGSize)size {
    size = CGSizeMake(size.width*1.5, size.height*1.5);
    CGSize newSize;
    if (size.width > ScreenWidth) {
        newSize.width = ScreenWidth;
        newSize.height = size.height/size.width * ScreenWidth;
    } else if (size.height > ScreenHeight) {
        newSize.height = ScreenHeight;
        newSize.width = size.width/size.height * ScreenHeight;
    } else {
        newSize = size;
    }
    return newSize;
}

// 获取图片
+ (UIImage *)getImageWithXMPPMessage:(XMPPMessage *)message {
    NSString *chatType = [message attributeStringValueForName:@"chatType"];
    
    if ([chatType isEqualToString:MessageTypeImage]) {
        NSString *base64str = [[message elementForName:@"attachment"] stringValue];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
        UIImage *image = [[UIImage alloc] initWithData:data];
        return image;
    }
    return nil;
}

@end
