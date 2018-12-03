//
//  MeTableViewCell.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "MeTableViewCell.h"
#import "XMPPvCardTemp.h"

@interface MeTableViewCell()
#pragma mark - Cell0
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickName;//昵称
@property (weak, nonatomic) IBOutlet UILabel *user;

#pragma mark - Cell1
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Cell0
- (void)updateCellFirst {
    // 显示当前用户的个人信息
    XMPPvCardTemp *myVCard = kXmppManager.vCard.myvCardTemp;
    
    // 设置头像
    if (myVCard.photo) {
        self.headerPic.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nickName.text = myVCard.nickname;
    
    // 设置用户名
    NSString *user = [IMUserInfo sharedIMUserInfo].user;
    self.user.text = [NSString stringWithFormat:@"用户名：%@",user];
}

#pragma mark - Cell1
- (void)updateCellSecond {
    
}

@end
