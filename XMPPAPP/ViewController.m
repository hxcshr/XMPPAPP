//
//  ViewController.m
//  XMPPAPP
//
//  Created by 何学成 on 2018/6/12.
//  Copyright © 2018年 qudao.tbkf.net. All rights reserved.
//

#import "ViewController.h"
#import "HHSignUpViewController.h"
#import "HHRosterController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBar];
    [self addViews];
}

- (void)setupNaviBar{
    self.title = @"登录";
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerClick:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)addViews{
    _nameField = [[UITextField alloc] init];
    _nameField.left = 16;
    _nameField.width = kScreenWidth - 32;
    _nameField.top = 20;
    _nameField.height = 40;
    _nameField.placeholder = @" 请输入用户名";
    _nameField.backgroundColor = [UIColor colorWithRGB:0xd7d7d7];
    [self.view addSubview:_nameField];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.top = _nameField.bottom + 16;
    _passwordField.left = _nameField.left;
    _passwordField.width = _nameField.width;
    _passwordField.height = _nameField.height;
    _passwordField.textContentType = UITextContentTypePassword;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @" 请输入密码";
    _passwordField.backgroundColor = [UIColor colorWithRGB:0x7d7d7d];
    [self.view addSubview:_passwordField];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.backgroundColor = [UIColor magentaColor];
    [submit setTitle:@"登录" forState:UIControlStateNormal];
    submit.top = _passwordField.bottom + 20;
    submit.left = 16;
    submit.width = _nameField.width;
    submit.height = 36;
    [submit addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}

- (void)loginClick:(id)sender{
    NSString *name = _nameField.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = _passwordField.text;
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length <= 0 || password.length <= 0) {
        [self showToastWith:@"请输入正确的用户名和密码"];
        return;
    }
    [self showWait];
    @weakify(self)
    [UserManager loginWithName:name password:password successHandle:^{
        UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:[HHRosterController new]];
        [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
        [weak_self hideHUD];
    } failedHandle:^{
        [weak_self hideHUD];
    }];
}

- (void)registerClick:(id)sender{
    [self.navigationController pushViewController:[HHSignUpViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
