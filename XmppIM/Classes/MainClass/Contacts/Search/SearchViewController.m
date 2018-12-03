//
//  SearchViewController.m
//  XmppIM
//
//  Created by 任 on 2018/11/5.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryCell.h"
#import "SearchHeader.h"
#import "SearchHistoryData.h"

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) SearchHeader *searchHeader;
@property (nonatomic, strong) UITableView *searchTable;

@property (nonatomic, strong) SearchHistoryData *historyData;
@end

@implementation SearchViewController

#pragma mark - lazy load
- (SearchHistoryData *)historyData {
    if (!_historyData) {
        _historyData = [[SearchHistoryData alloc] init];
    }
    return _historyData;
}

- (SearchHeader *)searchHeader {
    if (!_searchHeader) {
        _searchHeader = [SearchHeader addSearchHeader];
        _searchHeader.frame = CGRectMake(0, 20, ScreenWidth, 44);
        _searchHeader.searchEnable = YES;
        
        __weak typeof(self) weekSelf = self;
        _searchHeader.SearchCancelClickBlock = ^{
            [weekSelf dismissViewControllerAnimated:NO completion:nil];
            if (weekSelf.dismissVCBlock) {
                weekSelf.dismissVCBlock();
            }
        };
    }
    return _searchHeader;
}
- (UITableView *)searchTable {
    if (!_searchTable) {
        _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchHeader.bottom, ScreenWidth, ScreenHeight-self.searchHeader.height) style:UITableViewStyleGrouped];
        _searchTable.backgroundColor = [UIColor whiteColor];
        _searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchTable.delegate = self;
        _searchTable.dataSource = self;
        [self.view addSubview:_searchTable];
    }
    return _searchTable;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 1.检索框
    [self.view addSubview:self.searchHeader];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchHeader.searchTF becomeFirstResponder];
        self.searchHeader.searchTF.delegate = self;
    });
    
    // 2.历史记录
    [self.searchTable reloadData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyData.historyArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"SearchHistoryCell";
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchHistoryCell" owner:self options:nil] objectAtIndex:0];
        
        __weak typeof(cell) weekCell = cell;
        cell.deleteHistoryBlock = ^{
            [self.historyData deleleHistoryData:weekCell.historyLab.text];
            [self.searchTable reloadData];
        };
        
        if (self.historyData.historyArr.count) {
            cell.topLine.hidden = indexPath.row == 0 ? NO : YES;
            cell.historyLab.text = self.historyData.historyArr[indexPath.row];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.historyData.historyArr.count) {
        return 54;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.historyData.historyArr.count) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 0, ScreenWidth, 54);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        titleLabel.text = @"历史搜索";
        [headerView addSubview:titleLabel];
        
        return headerView;
    } else {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.historyData.historyArr.count) {
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
        [clearBtn setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        return clearBtn;
    } else {
        return [UIView new];
    }
}
- (void)clearBtnClick {
    [self.historyData removeHistoryData];
    [self.searchTable reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell clicked");
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (textField.text.length == 0) {
        return NO;
    }
    
    // 1.存历史记录
    [self.historyData addHistoryData:textField.text];
    // 2.跳转操作
    NSLog(@"跳转操作");
    [self.searchTable reloadData];
    
    return YES;
}


@end
