//
//  SearchHeader.h
//  XmppIM
//
//  Created by 任 on 2018/11/5.
//  Copyright © 2018年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHeader : UIView
+ (SearchHeader *)addSearchHeader;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;


/*
 * 检索框是否可点
 * YES  : 检索功能
 * NO   : 点击跳转功能
 */
@property (nonatomic, assign) Boolean searchEnable;

@property (nonatomic, copy) void(^SearchHeaderClickBlock)(void);
@property (nonatomic, copy) void(^SearchCancelClickBlock)(void);

- (void)moveSearchNoticeViewToCenter:(BOOL)moveCenter;
@end
