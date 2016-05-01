//
//  ChatViewController.m
//  家校通
//
//  Created by Sunny on 5/1/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () {
    UITabBar *_tabBar;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabBar = self.tabBarController.tabBar;
    NSString *launchAni = @"NO";
    [defaultNotiCenter postNotificationName:Noti_ShouldShowLaunchAnimation object:launchAni];
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bgView setImage:[UIImage imageNamed:@"chatBg"]];
    [self.view insertSubview:bgView belowSubview:self.conversationMessageCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideTabBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Status bar
- (void)hideTabBar {
    [UIView animateWithDuration:0.275
                     animations:^{
                         CGRect tabFrame = _tabBar.frame;
                         tabFrame.origin.x = CGRectGetMinX(tabFrame) - tabFrame.size.width;
                         _tabBar.frame = tabFrame;
                     }];
}

- (void)showTabBar {
    [UIView animateWithDuration:0.275
                     animations:^{
                         CGRect tabFrame = _tabBar.frame;
                         tabFrame.origin.x = CGRectGetMinX(tabFrame) + CGRectGetWidth(tabFrame);
                         _tabBar.frame = tabFrame;
                     }];
}

@end
