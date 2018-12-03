//
//  ImagesScrollView.h
//  XmppWeChat
//
//  Created by 任芳 on 2016/11/24.
//  Copyright © 2016年 任芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesScrollView : UIView

@property (nonatomic, strong) XMPPJID *friendJid; 
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) CGRect showImageRect;

@end
