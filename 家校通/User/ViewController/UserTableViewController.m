//
//  UserTableViewController.m
//  家校通
//
//  Created by Sunny on 4/28/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "UserTableViewController.h"
#import "MineCell.h"
#import "ChangePasswordViewController.h"
#import "LoginViewController.h"

@interface UserTableViewController () {
    UILabel *_passwordLabel;
    UIButton *_logoutBtn;
}

@end

@implementation UserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRef(240, 240, 240);
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Function
- (void)logout {
    TKAlertViewController *logoutAlert = [[TKAlertViewController alloc] initWithTitle:@"提示" message:@"即将注销，确定吗？"];
    [logoutAlert addButtonWithTitle:@"确定" block:^(NSUInteger index) {
        [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.shouldShowLaunchAnimation = NO;
        [self presentViewController:loginVC animated:NO completion:nil];
    }];
    [logoutAlert addButtonWithTitle:@"取消" block:nil];
    [logoutAlert showWithAnimationType:TKAlertViewAnimationPathStyle];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"MineIdentifier";
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.userIdLabel.text = [userDefaults objectForKey:keyUsername];
        switch ([[userDefaults objectForKey:keyUserType] intValue]) {
            case 0:
                cell.userTypeLabel.text = @"管理员";
                break;
            case 1:
                cell.userTypeLabel.text = @"教师";
                break;
            case 2:
                cell.userTypeLabel.text = @"学生";
                break;
            case 3:
                cell.userTypeLabel.text = @"家长";
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"PasswordIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_passwordLabel) {
            _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth/2, 44)];
            _passwordLabel.text = @"密码";
            [cell addSubview:_passwordLabel];
        }
        return cell;
    } else {
        static NSString *identifier = @"LogoutIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (!_logoutBtn) {
            _logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [_logoutBtn setTitle:@"注销登录" forState:UIControlStateNormal];
            [_logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [_logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_logoutBtn];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ChangePasswordViewController *changePasswdVC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswdVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

@end
