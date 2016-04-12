//
//  LoginViewController.m
//  家校通
//
//  Created by Sunny on 3/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "LoginViewController.h"
#import "LaunchDemo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _loginBtn.layer.cornerRadius = 5;
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

@end
