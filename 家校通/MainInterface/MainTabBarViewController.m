//
//  MainTabBarViewController.m
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "TempViewController.h"
#import "HomeworkTableViewController.h"

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* 添加子控制器 */
    //＊＊班级新闻
    _NewsVC = [[NewsViewController alloc] init];
    _NewsVC.isStatusBarHidden = _shouldShowLaunchAnimation;
    [self setUpChildControllerWith:_NewsVC norImage:[UIImage imageNamed:@"tabBar_essence_icon"] selImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] title:@"学院要闻"];
    
    //＊＊作业管理
    [self setUpChildControllerWith:[HomeworkTableViewController new] norImage:[UIImage imageNamed:@"tabBar_new_icon"] selImage:[UIImage imageNamed:@"tabBar_new_click_icon"] title:@"作业管理"];
    
    //＊＊实时交流
    [self setUpChildControllerWith:[TempViewController new] norImage:[UIImage imageNamed:@"tabBar_me_icon"] selImage:[UIImage imageNamed:@"tabBar_me_click_icon"] title:@"实时交流"];
    
    //＊＊用户管理
    [self setUpChildControllerWith:[TempViewController new] norImage:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"] title:@"用户管理"];
    
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

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    childVc.title = title;
    
    childVc.tabBarItem.image = norImage;
    childVc.tabBarItem.selectedImage = selImage;
    
    [self addChildViewController:nav];
}

#pragma mark - status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return _NewsVC;
}

@end
