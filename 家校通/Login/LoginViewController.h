//
//  LoginViewController.h
//  家校通
//
//  Created by Sunny on 3/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(UIButton *)sender;
//是否需要启动动画
@property (nonatomic, assign) BOOL shouldShowLaunchAnimation;

@end
