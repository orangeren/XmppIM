//
//  MainTabViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/28.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "MainTabViewController.h"
#import "CurrentViewController.h"
#import "ContactsViewController.h"
#import "MeViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 12.1, *)) {
        //iOS12.1的BUG tabbar跳动
        [[UITabBar appearance] setTranslucent:NO];
    }
    
    BaseNavigationController *mainNavi = [[BaseNavigationController alloc] initWithRootViewController:[CurrentViewController new]];
    BaseNavigationController *contactsNavi = [[BaseNavigationController alloc] initWithRootViewController:[ContactsViewController new]];
    BaseNavigationController *meNavi = [[BaseNavigationController alloc] initWithRootViewController:[MeViewController new]];
    self.viewControllers = @[mainNavi, contactsNavi, meNavi];
    
    
    NSArray *titles = @[@"消息", @"通讯录", @"我"];
    NSArray *normalImages = @[@"消息", @"通讯录", @"我"];
    NSArray *highlightImages = @[@"消息", @"通讯录", @"我"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = titles[idx];
        obj.image = [[UIImage imageNamed:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.selectedImage = [[UIImage imageNamed:highlightImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [obj setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont systemFontOfSize: 10]} forState:UIControlStateNormal];
        [obj setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize: 10]} forState:UIControlStateSelected];
        obj.titlePositionAdjustment = UIOffsetMake(0, 3); // 图片|文字 间距
    }];
}


@end
