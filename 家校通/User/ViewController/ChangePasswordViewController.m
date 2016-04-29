//
//  ChangePasswordViewController.m
//  家校通
//
//  Created by Sunny on 4/29/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UpdateUser.h"

@interface ChangePasswordViewController () <UITextFieldDelegate> {
    UIBarButtonItem *_saveBtn;
    UITextField *_passwordTextField;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRef(240, 240, 240);
    [self configView];
}

- (void)configView {
    _saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存  " style:UIBarButtonItemStylePlain target:self action:@selector(savePassword)];
    _saveBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = _saveBtn;
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [_passwordTextField setBackgroundColor:[UIColor whiteColor]];
    [_passwordTextField setPlaceholder:@"请输入新密码"];
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
}

#pragma mark - Function
- (void)savePassword {
    if (![_passwordTextField.text isEqualToString:@""]) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        WEAKSELF
        [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/user_manage/updateUserInfo.php" andDict:[weakSelf combineForChangePassword:_passwordTextField.text] finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            UpdateUser *model = [[UpdateUser alloc] initWithDictionary:responseObject error:nil];
            if ([model.responseCode isEqualToString:@"100"]) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SVProgressHUD showErrorWithStatus:@"修改失败！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    } else {
        TKAlertViewController *emptyAlert = [[TKAlertViewController alloc] initWithTitle:@"密码不能为空！" message:nil];
        [emptyAlert addButtonWithTitle:@"确定" block:nil];
        [emptyAlert show];
        [_passwordTextField resignFirstResponder];
    }
}

- (NSDictionary *)combineForChangePassword:(NSString *)newPassword {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[userDefaults objectForKey:keyUsername] forKey:@"user_id"];
    [dict setObject:@"Abandon" forKey:@"username"];
    [dict setObject:newPassword forKey:@"user_password"];
    [dict setObject:[userDefaults objectForKey:keyUserType] forKey:@"user_type"];
    return dict.copy;
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _saveBtn.enabled = YES;
}

@end
