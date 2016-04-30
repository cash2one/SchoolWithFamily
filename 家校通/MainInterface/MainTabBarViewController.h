//
//  MainTabBarViewController.h
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "HomeworkTableViewController.h"
#import "UserTableViewController.h"
#import "ChatListViewController.h"

@interface MainTabBarViewController : UITabBarController {
    BOOL _isStatusBarHidden;
}

//是否需要启动动画
@property (nonatomic, assign) BOOL shouldShowLaunchAnimation;

//子ViewController
@property (nonatomic, strong) NewsViewController *newsVC;
@property (nonatomic, strong) HomeworkTableViewController *homeworkVC;
@property (nonatomic, strong) UserTableViewController *userVC;
@property (nonatomic, strong) ChatListViewController *chatListVC;

@end
