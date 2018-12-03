//
//  CurrentViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "CurrentViewController.h"
#import "CurrentContacterCell.h"
#import "ChatViewController.h"

@interface CurrentViewController ()<NSFetchedResultsControllerDelegate>
/* 查询 最近联系人 控制器 */
@property (nonatomic, strong) NSFetchedResultsController *resultContrl_Near;

@property (nonatomic, strong) UIButton *myselfHead;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) XMPPJID *dialogueJid; // 当前聊天对象
@end

@implementation CurrentViewController

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

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
    }
    return _indicatorView;
}

- (NSFetchedResultsController *)resultContrl_Near {
    if (!_resultContrl_Near) {
        /* 1. 创建查询请求 */
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
        /* 2. 过滤，排序 */
        // a.当前登录用户的JID的「消息」
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", [IMUserInfo sharedIMUserInfo].jid];
        // b.时间降序
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO]];
        //c.分页
        fetchRequest.fetchOffset = 0;    //从第0条开始拿
        fetchRequest.fetchLimit = 20;    //每次拿20条
        
        /* 3. 执行请求获取数据 */
        _resultContrl_Near = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _resultContrl_Near.delegate = self;
        
        NSError *err = nil;
        [_resultContrl_Near performFetch:&err];
        if (err) {
            NSLog(@"%@",err);
        }
        
        // 刷新tableView
        if (!err) {
            [self.tableView reloadData];
        }
    }
    return _resultContrl_Near;
}



#pragma mark ------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    [self setUI];
    
    // 注册通知
    [self notification];
}

- (void)setUI {
    // 左按钮
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.myselfHead];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    self.navigationItem.leftBarButtonItems = @[item1, item2, item3];

    // 显示总未读数
    if ([IMAppCache allUnreadNum] == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [IMAppCache allUnreadNum]];
    }
}


- (void)notification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    /* 头像变更 */
    [center addObserverForName:UpdateMyvCardNotiKey object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getMyselfPhoto];
    }];
    
    /* 监听连接状态 */
    [center addObserverForName:kConnectStatusChangeNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int status = [note.userInfo[@"loginStatus"] intValue];
            [IMUserInfo sharedIMUserInfo].connectStatus = status;
            switch (status) {
                case XMPPResultTypeConnecting: { // 正在连接..
                    [self.indicatorView startAnimating];
                    // 自己的头像
                    [self getMyselfPhoto];
                    // 加载最近的聊天记录
                    [self updateData];
                }
                    break;
                default: {
                    [self.indicatorView stopAnimating];
                }
                    break;
            }
        });
    }];
    
    /* 1.监听从联系人列表 切到 消息列表  2.再进入「对话」页面 */
    [center addObserverForName:Notification_ToTabIndex0 object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        XMPPJID *friendJid = note.object;
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatViewController *chatVC = [ChatViewController new];
            chatVC.friendJid = friendJid;
            [self.navigationController pushViewController:chatVC animated:YES];
            self.dialogueJid = friendJid;
        });
    }];
    
    /* 监听message消息 */
    [center addObserverForName:Notification_ReceiveMessage object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        XMPPMessage *message = note.object;
        // 主线程中运行，否则刚启动应用时，得不到正确的未读消息数
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 未读数 */
            // 1. 拿到通话对象的Jid
            XMPPJID *msgOtherJid;
            XMPPJID *fromJid = message.from;
            XMPPJID *toJid = message.to;
            if (fromJid == nil) {// 我发消息给别人
                msgOtherJid = toJid;
            } else {// 别人发消息给我
                msgOtherJid = fromJid;
            }
            
            // 2. 信息发送人不是当前聊天人，记录为未读信息
            if (self.dialogueJid && [self.dialogueJid.user isEqualToString:msgOtherJid.user]) {
                // 有对话 忽略
            } else {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[IMAppCache getUnreadNumFromSanbox]];
                NSString *countValue = [dict objectForKey:msgOtherJid.user];
                if (countValue) {
                    // 已有 +1
                    int unreadNum = countValue.intValue;
                    unreadNum++;
                    [dict setObject:[NSString stringWithFormat:@"%d", unreadNum] forKey:msgOtherJid.user];
                } else {
                    // 没有 添加
                    [dict setObject:@"1" forKey:msgOtherJid.user];
                }
                [IMAppCache saveUnreadNumToSanbox:dict];
                
                // 更新总未读数
                if ([IMAppCache allUnreadNum] == 0) {
                    self.navigationController.tabBarItem.badgeValue = nil;
                } else {
                    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [IMAppCache allUnreadNum]];
                }
            }
        });
    }];
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

#pragma mark - 更新数据
- (void)updateData {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.resultContrl_Near performFetch:nil];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    ///////////LOG///////////////
    // 最新联系人
    //    XMPPMessageArchiving_Contact_CoreDataObject *lastContact = controller.fetchedObjects[0];
    //    NSLog(@"【（_resultContrl Delegate）最近联系人-消息】%ld 个 - %@",controller.fetchedObjects.count,lastContact.mostRecentMessageBody);
    /////////////////////////////
    
    // #pragma mark - 当数据的内容发生改变，刷新表格
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resultContrl_Near) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.resultContrl_Near.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CurrentContacterCell";
    CurrentContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CurrentContacterCell" owner:nil options:nil].firstObject;
    }
    cell.headPhoto.image = nil;
    
    // Configure the cell...
    XMPPMessageArchiving_Contact_CoreDataObject *contact = self.resultContrl_Near.fetchedObjects[indexPath.row];
    [cell updateCell:contact]; 
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Contact_CoreDataObject *contact = self.resultContrl_Near.fetchedObjects[indexPath.row];
    
    /* 跳转聊天界面*/
    ChatViewController *chatVC = [ChatViewController new];
    chatVC.friendJid = contact.bareJid;
    [self.navigationController pushViewController:chatVC animated:YES];
    self.dialogueJid = contact.bareJid;
    
    // 未读数
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[IMAppCache getUnreadNumFromSanbox]];
    if (contact.bareJid.user) {
        [dict removeObjectForKey:contact.bareJid.user];
    }
    [IMAppCache saveUnreadNumToSanbox:dict];
    
    // 更新总未读数
    if ([IMAppCache allUnreadNum] == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [IMAppCache allUnreadNum]];
    }
    
    // 更新样式
    CurrentContacterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.unReadTag.text = @"0";
    cell.unReadTag.hidden = YES;
}

@end
