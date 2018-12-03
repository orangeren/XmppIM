//
//  LoginViewController.m
//  XmppIM
//
//  Created by 任 on 2018/9/28.
//  Copyright © 2018年 RF. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (UIImageView *)createimageView:(NSString *)iconName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:iconName];
    return imageView;
}
- (void)initUI {
    self.usernameTF.leftView = [self createimageView:@"login_userName"];
    self.usernameTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.leftView = [self createimageView:@"login_password"];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *user = [IMUserInfo sharedIMUserInfo].user;
    self.usernameTF.text = user;
    
    self.usernameTF.text = @"renfang";
    self.passwordTF.text = @"renfang";
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    
    if (self.usernameTF.text.length && self.passwordTF.text.length) {
        IMUserInfo *userInfo = [IMUserInfo sharedIMUserInfo];
        userInfo.user = self.usernameTF.text;
        userInfo.pwd = self.passwordTF.text;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在登录中...";
        
        kXmppManager.registerOperation = NO;
        // Block 的强引用会造成内存泄漏问题，要转化为弱引用
        __weak typeof(self) selfVC = self;
        [kXmppManager xmppUserLogin:^(XMPPResultType type) {
            [selfVC handleResultType:type];
        }];
    } else {
        [MBProgressHUD showMessag:@"请输入用户名或密码" toView:self.view];
    }
}

- (void)handleResultType:(XMPPResultType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
            {
                NSLog(@"登录成功");
                [IMUserInfo sharedIMUserInfo].connectStatus = XMPPResultTypeLoginSuccess;
                [self enterMainPage];
            }
                break;
            case XMPPResultTypeLoginFailure:
            {
                NSLog(@"登录失败");
                [IMUserInfo sharedIMUserInfo].connectStatus = XMPPResultTypeLoginFailure;
                [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
            }
                break;
            case XMPPResultTypeNetErr:
            {
                NSLog(@"网络不给力");
                [IMUserInfo sharedIMUserInfo].connectStatus = XMPPResultTypeNetErr;
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
            }
                break;
            default:
                break;
        }
    });
}
- (void)enterMainPage {
    [IMUserInfo sharedIMUserInfo].loginStatus = YES;
    [[IMUserInfo sharedIMUserInfo] saveUserInfoToSanbox];
    
    self.view.window.rootViewController = [MainTabViewController new];
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
