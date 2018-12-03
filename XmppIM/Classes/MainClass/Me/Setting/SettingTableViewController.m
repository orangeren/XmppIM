//
//  SettingTableViewController.m
//  XmppIM
//
//  Created by 任 on 2018/10/15.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingDataSource.h"
#import "SettingTableViewCell.h"

#import "LogoutTipsView.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [SettingDataSource settingDataSource].count-1) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil][0];
            [cell updateCellFirst];
        }
        return cell;
    } else {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil][0];
            [cell updateCellFirst];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = [SettingDataSource settingDataSource][section];
    return sectionArr.count;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [SettingDataSource settingDataSource].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
    NSDictionary *dict = [SettingDataSource settingDataSource][indexPath.section][indexPath.row];
    NSString *cateName = dict[kSettingDataSourceName];
    if (cateName.intValue == SettingType_Logout) {
        [self logoutAction];
    }
}



#pragma mark - options
- (void)logoutAction {
    [LogoutTipsView tipsTitle:nil tipsDesc:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" tipsArr:@[@"退出登录"] cancel:@"取消" resultBlock:^(NSString *btnTitle) {
        if ([btnTitle isEqualToString:@"退出登录"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [kXmppManager xmppLogout];
        }
    }];
}


@end
