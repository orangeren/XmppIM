//
//  AddFriendViewController.m
//  XmppIM
//
//  Created by 任 on 2018/10/16.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddFriendDataSource.h"
#import "AddFriendsCell.h"

@interface AddFriendViewController ()<UITextFieldDelegate>

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [AddFriendDataSource addFriendDataSource][indexPath.section][indexPath.row];
    NSString *cellName = dict[kAddFriendDataSourceName]; 
    
    AddFriendsCell *cell;
    if (cellName.intValue == AddFriendName_InputFriendNo) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddFriendsCell" owner:nil options:nil][0];
            cell.searchFriendTF.delegate = self;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddFriendsCell" owner:nil options:nil][1];
            [cell updateCell1:dict];
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [AddFriendDataSource addFriendDataSource].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = [AddFriendDataSource addFriendDataSource][section];
    return sectionArr.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [AddFriendDataSource addFriendDataSource][indexPath.section][indexPath.row];
    NSString *cellName = dict[kAddFriendDataSourceName];
    if (cellName.intValue == AddFriendName_InputFriendNo) {
        return 44;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [AddFriendDataSource addFriendDataSource][indexPath.section][indexPath.row];
    NSString *cellName = dict[kAddFriendDataSourceName];
    if (cellName.intValue == AddFriendName_PhoneFriend) {
        // 手机通讯录
    }
}


#pragma mark - UITextFieldDelegate
// 添加好友
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 1.获取好友的帐号
    NSString *user = textField.text;
    NSString *jidStri = [NSString stringWithFormat:@"%@@%@", user, Domain];
    XMPPJID *friendid = [XMPPJID jidWithString:jidStri];
    
    // 2.发送好友添加请求
    // a).判断是否添加自己
    if ([user isEqualToString:[IMUserInfo sharedIMUserInfo].user]) {
        [MBProgressHUD showError:@"不能添加自己为好友" toView:self.view];
        return YES;
    }
    
    // b).判断好友是否存在
    if ([kXmppManager.rosterStorage userExistsWithJID:friendid xmppStream:kXmppManager.xmppStream]) {
        [MBProgressHUD showError:@"当前好友已经存在" toView:self.view];
        return YES;
    };
    
    // c).发送好友添加请求
    [kXmppManager.roster subscribePresenceToUser:friendid];
    
    return YES;
}

@end
