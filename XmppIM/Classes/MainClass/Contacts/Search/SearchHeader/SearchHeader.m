//
//  SearchHeader.m
//  XmppIM
//
//  Created by 任 on 2018/11/5.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SearchHeader.h"

#define Margin 10
#define NoticeViewWid 65

@interface SearchHeader()
@property (weak, nonatomic) IBOutlet UIView *searchNoticeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelWidCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTFRightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchNoticeViewCenterXCons;


@end

@implementation SearchHeader
+ (SearchHeader *)addSearchHeader {
    return [[NSBundle mainBundle] loadNibNamed:@"SearchHeader" owner:self options:nil].firstObject;
}

- (void)setSearchEnable:(Boolean)searchEnable {
    _searchEnable = searchEnable;

    self.searchTF.enabled = searchEnable ? YES : NO;
    self.searchNoticeView.hidden = searchEnable ? YES : NO;
    self.cancelWidCons.constant = searchEnable ? 60 : 0;
    self.searchTFRightCons.constant = searchEnable ? 0 : Margin;

    if (searchEnable) {
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search_sousuo"]];
        leftView.frame = CGRectMake(0, 0, 26, 26);
        self.searchTF.leftView = leftView;
        self.searchTF.leftViewMode = UITextFieldViewModeAlways;
        self.searchTF.placeholder = @"搜索";
    } else { // default
        self.searchTF.leftView = nil;
        [self addActionWithTarget:self action:@selector(searchViewClick)];
    }
}

- (void)searchViewClick {
    // 1.移动动画
    [self moveSearchNoticeViewToCenter:NO];
    // 2.跳转动作
    if (self.SearchHeaderClickBlock) {
        self.SearchHeaderClickBlock();
    }
}

- (void)moveSearchNoticeViewToCenter:(BOOL)moveCenter {
    if (moveCenter) {
        self.searchNoticeViewCenterXCons.constant = 0;
    } else {
        self.searchNoticeViewCenterXCons.constant = -(ScreenWidth-Margin*2-NoticeViewWid)/2;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}


- (IBAction)cancelClick:(id)sender {
    if (self.SearchCancelClickBlock) {
        self.SearchCancelClickBlock();
    }
}




@end
