//
//  SignUpViewController.m
//  家校通
//
//  Created by Sunny on 5/2/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "SignUpViewController.h"
#import "ChooseGroupViewController.h"
#import "SignUpModel.h"
#import "MainTabBarViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signUpBtn.layer.cornerRadius = 4;
    [defaultNotiCenter addObserver:self selector:@selector(changeBtnTitle:) name:Noti_ChooseGroup object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseGroup {
    ChooseGroupViewController *chooseGroupVC = [ChooseGroupViewController new];
    UINavigationController *nvVC = [[UINavigationController alloc] initWithRootViewController:chooseGroupVC];
    [self presentViewController:nvVC animated:YES completion:nil];
}

- (IBAction)signUp {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_signUpID.text forKey:@"user_id"];
    [dict setObject:@"unuse" forKey:@"username"];
    [dict setObject:_signUpPassword.text forKey:@"user_password"];
    [dict setObject:_group forKey:@"user_type"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:0.8]];
    [SVProgressHUD showWithStatus:@"正在注册..."];
    WEAKSELF
    MainTabBarViewController *mainVC = [MainTabBarViewController new];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/user_manage/addUser.php" andDict:dict.copy finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            SignUpModel *model = [[SignUpModel alloc] initWithDictionary:responseObject error:nil];
            if ([model.responseCode isEqualToString:@"100"]) {
                [userDefaults setObject:_signUpID.text forKey:keyUsername];
                [userDefaults setObject:_signUpPassword.text forKey:keyPassword];
                [userDefaults setObject:_group forKey:keyUserType];
                [appDelegate getToken];
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

- (IBAction)canncel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeBtnTitle:(NSNotification *)noti {
    [_groupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_groupBtn setTitle:noti.object forState:UIControlStateNormal];
    if ([noti.object isEqualToString:@"教师"]) {
        _group = @"1";
    } else if ([noti.object isEqualToString:@"学生"]) {
        _group = @"2";
    } else if ([noti.object isEqualToString:@"家长"]) {
        _group = @"3";
    }
}

- (void)dealloc {
    [defaultNotiCenter removeObserver:self];
}

@end
