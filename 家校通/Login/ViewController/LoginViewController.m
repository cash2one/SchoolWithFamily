//
//  LoginViewController.m
//  家校通
//
//  Created by Sunny on 3/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"

@interface LoginViewController () <UITextFieldDelegate>

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
    [self delayShowStatusBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _usernameField.text = [userDefaults objectForKey:keyUsername]?[userDefaults objectForKey:keyUsername]:@"";
    _passwordField.text = [userDefaults objectForKey:keyPassword]?[userDefaults objectForKey:keyPassword]:@"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_shouldShowLaunchAnimation) {
        [[LaunchDemo new] loadLaunchImage:@"LoginBg"
                                 iconName:nil
                              appearStyle:JRApperaStyleNone
                                  bgImage:@"LoginBg"
                                disappear:JRDisApperaStyleOne
                           descriptionStr:nil];
    }
}

#pragma mark - Function
- (NSDictionary *)combineParamsForLogin {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //act参数
    [dict setObject:_usernameField.text forKey:@"username"];
    [dict setObject:_passwordField.text forKey:@"password"];
    
    return dict.copy;
}

- (IBAction)login:(UIButton *)sender {
    MainTabBarViewController *mainVC = [MainTabBarViewController new];
    mainVC.shouldShowLaunchAnimation = NO;
    //登录指示器
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:0.8]];
    [SVProgressHUD showWithStatus:@"登录中..."];
    //网络请求
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *dict = [self combineParamsForLogin];
        [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/login.php" andDict:dict finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            LoginModel *model = [[LoginModel alloc] initWithDictionary:responseObject error:nil];
            if ([model.responseCode isEqualToString:@"100"]) {
                [userDefaults setObject:_usernameField.text forKey:keyUsername];
                [userDefaults setObject:_passwordField.text forKey:keyPassword];
                [userDefaults setObject:model.data forKey:keyUserType];
                [weakSelf dismissHud];
                [weakSelf presentViewController:mainVC animated:NO completion:nil];
            } else if ([model.responseCode isEqualToString:@"200"]) {
                [SVProgressHUD showErrorWithStatus:@"用户名或密码不正确！"];
                [weakSelf performSelector:@selector(dismissHud) withObject:nil afterDelay:1.5];
            } else {
                [SVProgressHUD showErrorWithStatus:@"连接服务器失败！"];
                [weakSelf performSelector:@selector(dismissHud) withObject:nil afterDelay:1.5];
            }
        } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败！"];
            [weakSelf performSelector:@selector(dismissHud) withObject:nil afterDelay:1.5];
        }];
    });
}

- (void)dismissHud {
    [SVProgressHUD dismiss];
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
    if (_shouldShowLaunchAnimation) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isStatusBarHidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        });
    } else {
        _isStatusBarHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
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
