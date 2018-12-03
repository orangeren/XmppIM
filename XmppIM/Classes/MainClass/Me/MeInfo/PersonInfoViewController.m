//
//  PersonInfoViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MeInfoDataSource.h"
#import "PersonInfoTableViewCell.h"
#import "HeadPicViewController.h"
#import "EditPersonInfoViewController.h"
#import "XMPPvCardTemp.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UpdateMyvCardNotiKey object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [MeInfoDataSource meInfoDataSource][indexPath.section][indexPath.row];
    NSString *cellName = dict[kMeInfoDataSourceName];
    NSString *cellTitle = dict[kMeInfoDataSourceTitle];
    
    PersonInfoTableViewCell *cell;
    if (cellName.intValue == MeInfoType_HeadPic) {// 头像
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInfoTableViewCell" owner:nil options:nil][0];
        }
        [cell updateCellUIWithCellName:cellName cellTitle:cellTitle];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInfoTableViewCell" owner:nil options:nil][1];
        }
        [cell updateCellUIWithCellName:cellName cellTitle:cellTitle];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [MeInfoDataSource meInfoDataSource].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = [MeInfoDataSource meInfoDataSource][section];
    return sectionArr.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    } else {
        return 44;
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
    NSDictionary *dict = [MeInfoDataSource meInfoDataSource][indexPath.section][indexPath.row];
    NSString *cellName = dict[kMeInfoDataSourceName];
    NSString *cellTitle = dict[kMeInfoDataSourceTitle];
    
    if (cellName.intValue == MeInfoType_HeadPic) {
        [self.navigationController pushViewController:[HeadPicViewController new] animated:YES];
    } else {
        PersonInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            EditPersonInfoViewController *editVC = [EditPersonInfoViewController new];
            editVC.showTitle = cellTitle;
            editVC.showValue = cell.showValue.text;
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:editVC];
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
}

@end
