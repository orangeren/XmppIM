//
//  MeViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "MeViewController.h"
#import "MeDataSource.h"
#import "MeTableViewCell.h"
#import "XMPPvCardTemp.h"
#import "PersonInfoViewController.h"
#import "SettingTableViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    self.title = @"我";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UpdateMyvCardNotiKey object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:self options:nil][0];
        }
        [cell updateCellFirst];
        return cell;
    }
    else {
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:self options:nil][1];
        }
        [cell updateCellSecond];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = [MeDataSource meDataSource][section];
    return sectionArr.count;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [MeDataSource meDataSource].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
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
    NSDictionary *dict = [MeDataSource meDataSource][indexPath.section][indexPath.row];
    NSString *cateName = dict[kMeDataSourceName];
    if (cateName.intValue == MeType_Me) {
        PersonInfoViewController *vc = [PersonInfoViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cateName.intValue == MeType_Setting) {
        [self.navigationController pushViewController:[SettingTableViewController new] animated:YES];
    }
}



@end
