//
//  EditPersonInfoViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/29.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "EditPersonInfoViewController.h"
#import "EditPersonInfoTableViewCell.h"

@interface EditPersonInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *editTF;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation EditPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"设置%@", self.showTitle];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"20d81f"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"2f6632"] forState:UIControlStateDisabled];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.saveBtn = saveBtn;
    self.saveBtn.enabled = NO;
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveBtnClick {
    EditPersonInfoTableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *editText = firstCell.editPersionInfo.text;
    if (editText.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"没有输入%@，请重新填写", self.meInfoDict[kMeInfoDataSourceTitle]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okaylAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [firstCell.editPersionInfo becomeFirstResponder];
        }];
        [alertController addAction:okaylAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    XMPPvCardTemp *vCard = kXmppManager.vCard.myvCardTemp;
    if ([self.title containsString:@"昵称"]) {
        vCard.nickname = editText;
    }
    // 更新 数据上传到服务器
    [kXmppManager.vCard updateMyvCardTemp:vCard];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditPersonInfoTableViewCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EditPersonInfoTableViewCell" owner:nil options:nil][0];
        cell.editPersionInfo.text = self.showValue;
        cell.editPersionInfo.delegate = self;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

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


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    EditPersonInfoTableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [firstCell.editPersionInfo resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textFieldStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
    textFieldStr = [textFieldStr substringToIndex:textFieldStr.length-range.length];
    self.saveBtn.enabled = [textFieldStr isEqualToString:self.showValue] ? NO : YES;
    
    return YES;
}

@end
