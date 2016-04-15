//
//  HomeworkDetailViewController.m
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "HomeworkDetailViewController.h"

@interface HomeworkDetailViewController () <UITextViewDelegate, UITextFieldDelegate> {
    UITabBar *_tabBar;
    UIBarButtonItem *_rightBarBtn;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation HomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabBar = self.tabBarController.tabBar;
    
    self.navigationItem.title = @"作业详情";
    _rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑  " style:UIBarButtonItemStylePlain target:self action:@selector(behavior)];
    self.navigationItem.rightBarButtonItem = _rightBarBtn;
    
    _titleTextField.delegate = self;
    _detailTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
    
    _scoreLabel.textColor = [UIColor grayColor];
    _scoreLabel.text = _score;
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

#pragma mark - function
- (void)behavior {
    if ([_rightBarBtn.title isEqualToString:@"编辑  "]) {
        _titleTextField.enabled = YES;
        _detailTextView.editable = YES;
        _rightBarBtn.title = @"取消编辑";
        [_titleTextField isFirstResponder];
    } else if ([_rightBarBtn.title isEqualToString:@"取消编辑"]) {
        _titleTextField.enabled = NO;
        _detailTextView.editable = NO;
        _rightBarBtn.title = @"编辑  ";
    } else if ([_rightBarBtn.title isEqualToString:@"完成"]) {
        [_titleTextField resignFirstResponder];
        [_detailTextView resignFirstResponder];
        _titleTextField.enabled = NO;
        _detailTextView.editable = NO;
        _rightBarBtn.title = @"保存";
    } else if ([_rightBarBtn.title isEqualToString:@"保存"]) {
        __block BOOL isSaved;
        //保存成功后返回，否则保存失败不返回
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"保存中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            isSaved = YES;
            if (isSaved) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SVProgressHUD showErrorWithStatus:@"保存失败！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        });
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_titleTextField resignFirstResponder];
    return YES;
}

-  (void)textFieldDidBeginEditing:(UITextField *)textField {
    _rightBarBtn.title = @"完成";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _rightBarBtn.title = @"完成";
}

@end
