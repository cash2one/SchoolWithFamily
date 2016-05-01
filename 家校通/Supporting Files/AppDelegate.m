//
//  AppDelegate.m
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "RongTokenModel.h"

@interface AppDelegate () <RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUI];
    [self setupRoot];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupRoot {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:keyUsername] && [defaults objectForKey:keyPassword]) {
        MainTabBarViewController *mainVC = [MainTabBarViewController new];
        mainVC.shouldShowLaunchAnimation = YES;
        self.window.rootViewController = mainVC;
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.shouldShowLaunchAnimation = YES;
        self.window.rootViewController = loginVC;
    }
    [self.window makeKeyAndVisible];
}

- (void)setupUI {
    //设置标题栏颜色
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:kCommonColor];
    //设置导航栏标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置按钮文字颜色 白色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置导航栏按钮字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    //去掉导航栏黑线
    [[UINavigationBar appearance] setShadowImage:[UIImage imageFromColor:[UIColor clearColor] corner:CornerAll radius:0]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor] corner:CornerAll radius:0] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - RongCloud
- (void)getToken {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[userDefaults objectForKey:keyUsername] forKey:@"userId"];
    [dict setObject:[userDefaults objectForKey:keyUsername] forKey:@"name"];
    [dict setObject:@"http://zesicus.site/interface/school_manager/IMG/MBNormal.png" forKey:@"portraitUri"];
    [[NetworkManager sharedManager] requestRCWithUrl:@"https://api.cn.ronghub.com/user/getToken.json" andDict:dict.copy finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        RongTokenModel *model = [[RongTokenModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.code isEqualToString:@"200"]) {
            [userDefaults setObject:model.token forKey:keyToken];
            [self connectRongCloud];
        }
    } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Get token error: /n%@", error);
    }];
}

- (void)connectRongCloud {
    [[RCIM sharedRCIM] initWithAppKey:@"lmxuhwagxvsmd"];
    [RCIM sharedRCIM].enableTypingStatus = YES; //用户输入状态
    NSString *token = [userDefaults objectForKey:keyToken];
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    if ([userId isEqualToString:[userDefaults objectForKey:keyUsername]]) {
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = userId;
        userInfo.name = userId;
        userInfo.portraitUri = @"http://zesicus.site/interface/school_manager/IMG/MBNormal.png";
        return completion(userInfo);
    } else {
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = userId;
        userInfo.name = userId;
        userInfo.portraitUri = @"http://zesicus.site/interface/school_manager/IMG/MBTalking.png";
        return completion(userInfo);
    }
}

@end
