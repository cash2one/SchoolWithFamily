//
//  LoginViewController.m
//  家校通
//
//  Created by Sunny on 3/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (IBAction)login:(UIButton *)sender {
    MainTabBarViewController *mainVC = [MainTabBarViewController new];
    [self presentViewController:mainVC animated:YES completion:nil];
}

//白色状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
