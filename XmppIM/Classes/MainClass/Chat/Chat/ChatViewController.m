//
//  ChatViewController.m
//  XmppIM
//
//  Created by 任 on 2018/11/8.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "ChatViewController.h"
#import "IMInputView.h"
#import "ChatTableViewCell.h"
#import "DialogPopView.h"
#import "ExpressionConfig.h"

@interface ChatViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> { 
    NSString *_currentTimeStr; //当前添加的时间字符串
}
/* 查询 Chat 控制器 */
@property (nonatomic, strong) NSFetchedResultsController *resultContrl_Chat;

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) IMInputView *inputView;

// 数据
@property (strong, nonatomic) NSMutableArray *dataSources;  //里边存的都是消息模型
@end

@implementation ChatViewController


#pragma mark lazy load
- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] init];
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.translatesAutoresizingMaskIntoConstraints = NO;
        //_mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//效果不太好
        [self.view addSubview:_mainTable];
        
        [_mainTable addActionWithTarget:self action:@selector(hiddenKeyboardWhenTapMainTable)];
    }
    return _mainTable;
}
- (void)hiddenKeyboardWhenTapMainTable {
    [self.inputView setInputUIWithState:ChatInputStatusNothing];
}

- (IMInputView *)inputView {
    if (!_inputView) {
        _inputView = [IMInputView inputView];
        _inputView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_inputView];
    }
    return _inputView;
}


- (NSFetchedResultsController *)resultContrl_Chat {
    if (!_resultContrl_Chat) {
        // 1.初始化查询请求
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        
        // 2.过滤，排序
        //a.1.当前登录用户的JID的消息 2.好友的JID的消息
        request.predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@", [IMUserInfo sharedIMUserInfo].jid, self.friendJid.bare];
        //b.时间升序
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
        
        // 3.初始化查询结果控制器
        _resultContrl_Chat = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _resultContrl_Chat.delegate = self;
        
        NSError *err = nil;
        [_resultContrl_Chat performFetch:&err];
        if (err) {
            NSLog(@"err - %@",err);
        }
        
        
        /* 添加到数据源 */
        for (XMPPMessageArchiving_Message_CoreDataObject *msg in _resultContrl_Chat.fetchedObjects) {
            [self addDataSourcesWithMessage:msg];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /* 滚动到底部 */
            [self scrollToTableBottom:NO];
        });
    }
    return _resultContrl_Chat;
}
// 1.加入数据源的方法
- (void)addDataSourcesWithMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    XMPPMessage *xmppmessage = message.message;
    NSString *chatType = [xmppmessage attributeStringValueForName:@"chatType"];
    if ([chatType isEqualToString:MessageTypeAudio] || [chatType isEqualToString:MessageTypeVedio]) {
        // 音视频
        NSString *base64str = [[xmppmessage elementForName:@"attachment"] stringValue];
        NSData *data = [base64str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (dict && [dict[@"type"] isEqualToString:@"bye"]) {
            // 数据源中 除了 {@"type":@"bye",etc..}, 音视频码 不添加到数据源中
            [self addDataSourcesWithMessageAndTime:message];
        }
    } else {
        [self addDataSourcesWithMessageAndTime:message];
    }
}
// 2.数据源是否要加「时间」
- (void)addDataSourcesWithMessageAndTime:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    // 1.判断message对象前面是否要加『时间』
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestamp = [fmt stringFromDate:message.timestamp];
    if (_currentTimeStr.length == 0) {
        [self.dataSources addObject:[Common timeStr:message.timestamp]];
    } else {
        // 计算聊天时差 timestamp - _currentTimeStr
        NSInteger difference = [Common differencewithDate:_currentTimeStr toDate:timestamp];
        if (difference > 30) {
            [self.dataSources addObject:[Common timeStr:message.timestamp]];
        }
    }
    _currentTimeStr = timestamp;
    
    
    // 2.再加message
    [self.dataSources addObject:message];
}

// 滚动到底部
- (void)scrollToTableBottom:(BOOL)animated {
    NSInteger lastRow = _dataSources.count - 1;
    if (lastRow < 0) { // 行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.mainTable scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


#pragma mark ------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.friendJid.user;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

- (void)setUI {
    /* 约束 */
    NSDictionary *views = @{@"tableView":self.mainTable,
                            @"inputView":self.inputView};
    // 1.tabview水平方向的约束
    NSArray *tableviewHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableviewHCons];
    // 2.inputView水平方向的约束
    NSArray *inputViewHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHCons];
    // 垂直方向的约束
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vCons];
    
    // 约束控制
    self.inputView.inputViewHeiCons = vCons[2];
    self.inputView.inputButtomViewCons = [vCons lastObject];
    self.inputView.friendJid = self.friendJid;
    self.inputView.superVC = self;
    __weak typeof(self) weekSelf = self;
    self.inputView.scrollBottomBlock = ^{//滚动到底部
        [weekSelf scrollToTableBottom:YES];
    };
}



#pragma mark - NSFetchedResultsControllerDelegate
/* 当数据的内容发生改变，刷新表格 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    XMPPMessageArchiving_Message_CoreDataObject *msg = [controller.fetchedObjects lastObject];
    NSLog(@"msg.body-- %@ bareJidStr-- %@ -- %@ -- %@", msg.body, msg.bareJidStr, msg.streamBareJidStr, msg.outgoing);
    
    [self.mainTable reloadData];
    [self scrollToTableBottom:YES];
}

/* 当数据发生变化时，点对点的更新tableview，这样大大的提高了更新效率 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    XMPPMessageArchiving_Message_CoreDataObject *msg = anObject;
    NSLog(@"输入状态 - %lu  body - %@",(unsigned long)type,msg.body);
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            //插入
            [self addDataSourcesWithMessage:msg];
        }
            break;
        case NSFetchedResultsChangeDelete: {
            //删除
            [self.dataSources removeLastObject];
            //删除时间
            if ([self.dataSources.lastObject isKindOfClass:[NSString class]]) {
                [self.dataSources removeLastObject];
            }
        }
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
            
        default:
            break;
    }
}

 
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resultContrl_Chat) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellObj = self.dataSources[indexPath.row];
    // 时间cell
    if ([cellObj isKindOfClass:[NSString class]]) {
        return 20;
    }
    else {
        XMPPMessageArchiving_Message_CoreDataObject *msg = self.dataSources[indexPath.row];
        XMPPMessage *message = msg.message;
        NSString *chatType = [message attributeStringValueForName:@"chatType"];
        
        // 图片
        if ([chatType isEqualToString:MessageTypeImage]) {
            // base64
            NSString *base64str = [[message elementForName:@"attachment"] stringValue];
            NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
            UIImage *image = [[UIImage alloc] initWithData:data];
            DialogPopView *popView = [[DialogPopView alloc] init];
            CGSize size = [popView getImageSize:image];
            return size.height+28;
        }
        // 语音
        else if ([chatType isEqualToString:MessageTypeVoice] || [chatType isEqualToString:MessageTypeAudio] || [chatType isEqualToString:MessageTypeVedio]) {
            return 64;
        }
        // 文本
        else {//if ([chatType isEqualToString:MessageTypeText]) {
            // 纯文本
            NSString *bodyStr = msg.body;
            if (!msg.body) {
                bodyStr = @"...";
            }
            
            UIFont *font = [UIFont systemFontOfSize:14];
            // 普通文本 转 富文本
            NSAttributedString *attrStr = [ExpresstionTools generateAttributeStringWithOriginalString:bodyStr fontSize:font.pointSize];
            // 计算高度
            CGSize size = [attrStr boundingRectWithSize:CGSizeMake(ScreenWidth-165.0f,CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            return size.height+50;
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ChatCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    
    // Configure the cell...
    id cellObj = self.dataSources[indexPath.row];
    
    // 时间cell
    if ([cellObj isKindOfClass:[NSString class]]) {
        NSString *timeStr = _dataSources[indexPath.row];
        [cell cellStyleForTime:timeStr];
        return cell;
    }
    else {
        // 获取聊天消息对象
        XMPPMessageArchiving_Message_CoreDataObject *msg = self.dataSources[indexPath.row];
        
        // 必传
        cell.friendJid = self.friendJid;
        cell.outgoing = msg.outgoing;
        cell.timestamp = msg.timestamp;
        
        // 判断是图片 还是纯文本
        XMPPMessage *message = msg.message;
        NSString *chatType = [message attributeStringValueForName:@"chatType"];
        // 显示图片
        if ([chatType isEqualToString:MessageTypeImage]) {
            // URL
            //NSString *urlStr = msg.body;
            //[cell cellStyleForImage:urlStr];
            
            // base64
            NSString *base64str = [[message elementForName:@"attachment"] stringValue];
            [cell cellStyleForImageWithData:base64str];
        }
        // 显示语音
        else if ([chatType isEqualToString:MessageTypeVoice]) {
            // base64
            NSString *base64str = [[message elementForName:@"attachment"] stringValue];
            [cell cellStyleForVoiceWithData:base64str indexRow:indexPath.row];
        }
        // 显示 1.音频通话； 2.视频通话
        else if ([chatType isEqualToString:MessageTypeAudio] || [chatType isEqualToString:MessageTypeVedio]) {
            NSString *attachment = [[message elementForName:@"attachment"] stringValue];
            [cell cellStyleForAudioVedio:attachment];
        }
        // 显示文本
        else// if ([chatType isEqualToString:MessageTypeText])
        { // @"text"
            [cell cellStyleForText:msg.body];
        }
        return cell;
    }
}

// 滚动tableView的时候，收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.inputView.status == ChatInputStatusShowKeyboard || self.inputView.status == ChatInputStatusShowEmoji || self.inputView.status == ChatInputStatusShowMore)
    [self.inputView setInputUIWithState:ChatInputStatusNothing];
}

@end
