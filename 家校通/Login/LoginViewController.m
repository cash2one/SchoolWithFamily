//
//  LoginViewController.m
//  家校通
//
//  Created by Sunny on 3/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate> {
    BOOL _isStatusBarHidden;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //文本框相关
    _loginBtn.layer.cornerRadius = 4;
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    [_usernameField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_passwordField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerTextField)];
    [self.view addGestureRecognizer:tapBg];
    
    //延迟显示状态栏
    _isStatusBarHidden = YES;
    [self delayShowStatusBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LaunchDemo new] loadLaunchImage:@"LoginBg"
                             iconName:nil
                          appearStyle:JRApperaStyleNone
                              bgImage:@"LoginBg"
                            disappear:JRDisApperaStyleOne
                       descriptionStr:nil];
}

- (IBAction)login:(UIButton *)sender {
    MainTabBarViewController *mainVC = [MainTabBarViewController new];
    [self presentViewController:mainVC animated:YES completion:nil];
}

//有输入情况激活登录按钮
- (void)textFieldDidChange {
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        _loginBtn.enabled = NO;
    } else {
        _loginBtn.enabled = YES;
    }
}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden {
    return _isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)delayShowStatusBar {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isStatusBarHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self registerTextField];
    return YES;
}

- (void)registerTextField {
    [_passwordField resignFirstResponder];
    [_usernameField resignFirstResponder];
}

@end
