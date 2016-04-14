//
//  HomeworkDetailViewController.m
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "HomeworkDetailViewController.h"

@interface HomeworkDetailViewController () {
    UITabBar *_tabBar;
}

@end

@implementation HomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabBar = self.tabBarController.tabBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self showTabBar];
}

#pragma mark - Tab bar
- (void)hideTabBar {
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect tabFrame = _tabBar.frame;
                         tabFrame.origin.y = CGRectGetMinY(tabFrame) + tabFrame.size.height;
                         _tabBar.frame = tabFrame;
                     }];
}

- (void)showTabBar {
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect tabFrame = _tabBar.frame;
                         tabFrame.origin.y = CGRectGetMinY(tabFrame) - CGRectGetHeight(tabFrame);
                         _tabBar.frame = tabFrame;
                     }];
}

@end
