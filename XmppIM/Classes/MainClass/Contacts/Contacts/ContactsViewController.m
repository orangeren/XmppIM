//
//  ContactsViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"
#import "SearchHeader.h"
#import "AddFriendViewController.h"
#import "SearchViewController.h"
#import "XMPPvCardTemp.h"

@interface ContactsViewController ()<NSFetchedResultsControllerDelegate>
/* 查询好友控制器 */
@property (nonatomic, strong) NSFetchedResultsController *resultContrl;


@property (nonatomic, strong) UIButton *myselfHead;
@property (nonatomic, strong) SearchHeader *searchHeader;

@end

@implementation ContactsViewController

#pragma mark - lazy load
- (UIButton *)myselfHead {
    if (!_myselfHead) {
        _myselfHead = [UIButton buttonWithType:UIButtonTypeCustom];
        _myselfHead.frame = CGRectMake(0, 0, 40, 40);
        _myselfHead.layer.cornerRadius = 20;
        _myselfHead.layer.masksToBounds = YES;
        [_myselfHead setBackgroundImage:[Common scaleImage:[UIImage imageNamed:@"defaultPhoto"] toSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [_myselfHead addTarget:self action:@selector(myselfBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myselfHead;
}
- (void)myselfBtnClick {
    NSLog(@"点击自己的头像");
}

- (SearchHeader *)searchHeader {
    if (!_searchHeader) {
        _searchHeader = [SearchHeader addSearchHeader];
        _searchHeader.frame = CGRectMake(0, 0, ScreenWidth, 44);
        _searchHeader.searchEnable = NO;
        
        __weak typeof(self) weekSelf = self;
        _searchHeader.SearchHeaderClickBlock = ^{
            [weekSelf.navigationController setNavigationBarHidden:YES animated:YES];
            
            SearchViewController *searchVC = [SearchViewController new];
            // push
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weekSelf presentViewController:searchVC animated:NO completion:nil];
            });
            // pop
            searchVC.dismissVCBlock = ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weekSelf.navigationController setNavigationBarHidden:NO animated:YES];
                    [weekSelf.searchHeader moveSearchNoticeViewToCenter:YES];
                });
            };
        };
    }
    return _searchHeader;
}

- (NSFetchedResultsController *)resultContrl {
    if (!_resultContrl) {
        /* 1. 创建查询请求 */
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
        /* 2. 设置查询请求的属性 */
        // a.排序
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES]];
        // b.过滤当前用户的好友
        // 互为好友
        //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subscription == 'both'"];
        // 我的好友
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", [IMUserInfo sharedIMUserInfo].jid];
        /* 3. 执行请求获取数据 */
        _resultContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        /* 4. delegate */
        _resultContrl.delegate = self;

        NSError *err = nil;
        [_resultContrl performFetch:&err];
        if (err) {
            NSLog(@"err - %@",err);
        }

        if (!err) {
            [self.tableView reloadData];
        }
    }
    return _resultContrl;
}



#pragma mark ------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    [self setUI];
}
- (void)setUI {
    // 左按钮 头像
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myselfHead];
    // 右按钮 添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Con_addFriends"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick)];

    // 检索框
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [headerView addSubview:self.searchHeader];
    self.tableView.tableHeaderView = headerView;

    // 自己的头像
    [self getMyselfPhoto];
    [[NSNotificationCenter defaultCenter] addObserverForName:UpdateMyvCardNotiKey object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getMyselfPhoto];
    }];
}
- (void)addBtnClick {
    [self.navigationController pushViewController:[AddFriendViewController new] animated:YES];
}


#pragma mark - 自己的头像
- (void)getMyselfPhoto {
    UIImage *selfPhoto;
    XMPPvCardTemp *myVCard = [IMXmppManager sharedManager].vCard.myvCardTemp;
    if (myVCard.photo) {
        selfPhoto = [UIImage imageWithData:myVCard.photo];
    } else {
        selfPhoto = [UIImage imageNamed:@"defaultPhoto"];
    }
    [self.myselfHead setBackgroundImage:[Common scaleImage:selfPhoto toSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self updateData];
}


// -------- 更新数据 --------
- (void)updateData {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.resultContrl performFetch:nil];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}


#pragma mark - NSFetchedResultsControllerDelegate
// 当数据的内容发生改变(添加好友/删除好友)
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultContrl.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* 获取对应的组的数据集合 */
    id <NSFetchedResultsSectionInfo> fetchedResultsSectionInfo = self.resultContrl.sections[section];
    /* 获取 info 的元素数量 */
    return [fetchedResultsSectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:nil options:nil].firstObject;
    } 
    
    // Configure the cell...
    cell.headPhoto.image = nil;
    XMPPUserCoreDataStorageObject *friend = [self.resultContrl objectAtIndexPath:indexPath];
    
    // 展示名
    cell.displayName.text = friend.jid.user;
    // 头像
    NSData *photoData = [kXmppManager.avatar photoDataForJID:friend.jid];
    if (photoData) {
        cell.headPhoto.image = [UIImage imageWithData:photoData];
    } else {
        cell.headPhoto.image = [UIImage imageNamed:@"defaultPhoto"];
    }
    // sectionNum : 0 - 在线  1 - 离开  2 - 离线
    switch ([friend.sectionNum intValue]) {//好友状态
        case 0:
            cell.loginStatus.text = @"在线";
            break;
        case 1:
            cell.loginStatus.text = @"离开";
            break;
        case 2: {
            cell.loginStatus.text = @"离线";

            if (photoData) {
                cell.headPhoto.image = [Common grayImage:[UIImage imageWithData:photoData]];
            } else {
                cell.headPhoto.image = [Common grayImage:[UIImage imageNamed:@"defaultPhoto"]];
            }
        }
            break;
        default:
            break;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.resultContrl.sectionIndexTitles[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.resultContrl.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 0;
}

/* 侧滑删除 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend = [self.resultContrl objectAtIndexPath:indexPath];
        [kXmppManager.roster removeUser:friend.jid];
    }
}

/* 点击好友cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取好友
    XMPPUserCoreDataStorageObject *friend = [self.resultContrl objectAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ToTabIndex0 object:friend.jid];
    self.tabBarController.selectedIndex = 0;
}


@end
