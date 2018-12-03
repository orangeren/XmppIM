//
//  AddMoreView.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/12/1.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputConfig.h"

@protocol AddMoreViewDelegate <NSObject>
@optional
// 发送图片（一张）
- (void)sendImageWithData:(NSData *)imageData bodyMsg:(NSString *)bodyMsg;
// 发送图片（数组）
- (void)sendImages:(NSArray<NSData *> *)imageDataArr bodyMsg:(NSString *)bodyMsg;

// 发送位置
//- (void)sendLocationWithBMKPoiInfo:(BMKPoiInfo *)poiInfo;

@end


@interface AddMoreView : UIView
+ (AddMoreView *)addMoreView;
@property (nonatomic, weak) id<AddMoreViewDelegate>delegate;

@property (nonatomic, strong) XMPPJID *remoteJID;
@end
