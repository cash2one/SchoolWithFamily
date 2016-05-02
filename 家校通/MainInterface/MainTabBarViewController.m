//
//  MainTabBarViewController.m
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "MainTabBarViewController.h"

@implementation MainTabBarViewController

+ (void)initialize {
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
    selDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (_shouldShowLaunchAnimation) {
        [appDelegate connectRongCloud];
    }
    [defaultNotiCenter addObserver:self selector:@selector(shouldShowLaunchAnimation:) name:Noti_ShouldShowLaunchAnimation object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self delayShowStatusBar];
    
    /* 添加子控制器 */
    //＊＊新闻
    _newsVC = [[NewsViewController alloc] init];
    [self setUpChildControllerWith:_newsVC norImage:[UIImage imageNamed:@"tabBar_essence_icon"] selImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] title:@"要闻"];
    
    //＊＊作业
    _homeworkVC = [HomeworkTableViewController new];
    [self setUpChildControllerWith:_homeworkVC norImage:[UIImage imageNamed:@"tabBar_new_icon"] selImage:[UIImage imageNamed:@"tabBar_new_click_icon"] title:@"作业"];
    
    //＊＊交流
    _chatListVC = [ChatListViewController new];
    [self setUpChildControllerWith:_chatListVC norImage:[UIImage imageNamed:@"tabBar_me_icon"] selImage:[UIImage imageNamed:@"tabBar_me_click_icon"] title:@"交流"];
    
    //＊＊我的
    _userVC = [UserTableViewController new];
    [self setUpChildControllerWith:_userVC norImage:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"] title:@"我的"];
    
    //＊＊设置tabBar工具条
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    //设置选中标题栏图像颜色
    [self.tabBar setTintColor:[UIColor colorWithRed:81/255.f green:81/255.f blue:81/255.f alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated {
    //是否执行动画，由登录页面进入则不显示动画
    if (_shouldShowLaunchAnimation) {
        [[LaunchDemo new] loadLaunchImage:@"LoginBg"
                                 iconName:nil
                              appearStyle:JRApperaStyleNone
                                  bgImage:@"LoginBg"
                                disappear:JRDisApperaStyleOne
                           descriptionStr:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [defaultNotiCenter removeObserver:self];
}

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    childVc.title = title;
    
    childVc.tabBarItem.image = norImage;
    childVc.tabBarItem.selectedImage = selImage;
    
    [self addChildViewController:nav];
}

#pragma mark - Status bar
- (void)delayShowStatusBar {
    if (_shouldShowLaunchAnimation) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        });
    }
}

#pragma mark - Other
- (void)shouldShowLaunchAnimation:(NSNotification *)noti {
    _shouldShowLaunchAnimation = [noti.object boolValue];
}

@end
