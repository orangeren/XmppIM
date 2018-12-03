//
//  PersonInfoTableViewCell.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "PersonInfoTableViewCell.h"
#import "MeInfoDataSource.h"
#import "XMPPvCardTemp.h"
 
@implementation PersonInfoTableViewCell
 
- (void)updateCellUIWithCellName:(NSString *)cellname cellTitle:(NSString *)celltitle;{
    // 显示当前用户的个人信息
    XMPPvCardTemp *myVCard = kXmppManager.vCard.myvCardTemp;
    
    self.title.text = celltitle;
    if (cellname.intValue == MeInfoType_HeadPic) { 
        if (myVCard.photo) {
            [self.headPic setImage:[UIImage imageWithData:myVCard.photo] forState:UIControlStateNormal];
        }
    } else if (cellname.intValue == MeInfoType_NickName) {
        self.showValue.text = myVCard.nickname;
    } else if (cellname.intValue == MeInfoType_UserName) {
        self.accessoryType = UITableViewCellAccessoryNone;
        NSString *user = [IMUserInfo sharedIMUserInfo].user;
        self.showValue.text = [NSString stringWithFormat:@"%@",user];
        self.rightCons.constant = 34;
    }
    
//    else if ([title isEqualToString:@"公司"]) {
//        self.showValue.text = myVCard.orgName;
//    } else if ([title isEqualToString:@"部门"]) {
//        if(myVCard.orgUnits.count > 0) {
//            self.showValue.text = myVCard.orgUnits[0];
//        }
//    } else if ([title isEqualToString:@"职位"]) {
//        self.showValue.text = myVCard.title;
//    } else if ([title isEqualToString:@"电话"]) {
//        self.showValue.text = myVCard.note;
//    } else if ([title isEqualToString:@"邮件"]) {
//        if (myVCard.emailAddresses.count > 0) {
//            self.showValue.text = myVCard.emailAddresses[0];
//        }
//    }
}

@end
