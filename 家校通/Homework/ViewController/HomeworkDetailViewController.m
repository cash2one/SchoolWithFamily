//
//  HomeworkDetailViewController.m
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "HomeworkDetailViewController.h"
#import "UpdateHomework.h"

@interface HomeworkDetailViewController () <UITextViewDelegate, UITextFieldDelegate> {
    UITabBar *_tabBar;
    UIBarButtonItem *_rightBarBtn;
}

@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UILabel *uploaderLabel;
@property (strong, nonatomic) UITextView *detailTextView;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *scoreLabel;

@end

@implementation HomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tabBar = self.tabBarController.tabBar;
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeUIText];
    [self hideTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self showTabBar];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addSubviews {
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 20, kScreenWidth-32, 40)];
    [_titleTextField setFont:[UIFont systemFontOfSize:22.0]];
    [_titleTextField setTextAlignment:NSTextAlignmentCenter];
    _titleTextField.delegate = self;
    [_titleTextField setEnabled:NO];
    [self.view addSubview:_titleTextField];
    
    _uploaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20+40+8, kScreenWidth-32, 20)];
    [_uploaderLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_uploaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_uploaderLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:_uploaderLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, kScreenHeight-10-20-64, 200, 20)];
    [_dateLabel setTextColor:[UIColor grayColor]];
    [_dateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:_dateLabel];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, kScreenHeight-10-20-64, kScreenWidth-232, 20)];
    [_scoreLabel setTextColor:[UIColor grayColor]];
    [_scoreLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_scoreLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_scoreLabel];
    
    _detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 96, kScreenWidth-32, kScreenHeight-96-40-64)];
    [_detailTextView setFont:[UIFont systemFontOfSize:15.0]];
    _detailTextView.delegate = self;
    [_detailTextView setEditable:NO];
    [self.view addSubview:_detailTextView];
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
- (void)changeUIText {
    self.navigationItem.title = @"作业详情";
    if ([[userDefaults objectForKey:keyUserType] isEqualToString:@"2"] && [_score isEqualToString:unmarked]) {
        _rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑  " style:UIBarButtonItemStylePlain target:self action:@selector(btnBehavior)];
    } else if ([[userDefaults objectForKey:keyUserType] isEqualToString:@"1"]) {
        _rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"评分  " style:UIBarButtonItemStylePlain target:self action:@selector(btnBehavior)];
    } else {
        _rightBarBtn = nil;
    }
    
    self.navigationItem.rightBarButtonItem = _rightBarBtn;
    _titleTextField.text = _homeworkTitle;
    _uploaderLabel.text = _uploader;
    _detailTextView.text = _homeworkDetail;
    _dateLabel.text = _uploadDate;
    _scoreLabel.text = _score;
    if ([_score isEqualToString:unmarked]) {
        _scoreLabel.textColor = [UIColor grayColor];
    } else {
        _scoreLabel.textColor = [UIColor redColor];
    }
}

- (void)btnBehavior {
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
        _titleTextField.enabled = YES;
        _detailTextView.editable = YES;
        _rightBarBtn.title = @"保存";
    } else if ([_rightBarBtn.title isEqualToString:@"保存"]) {
        //保存成功后返回，否则保存失败不返回
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"保存中..."];
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = [weakSelf combineParamsForUpdateHomework];
            [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/updateHomeworkForStu.php" andDict:dict finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                UpdateHomework *model = [[UpdateHomework alloc] initWithDictionary:responseObject error:nil];
                if ([model.responseCode isEqualToString:@"100"]) {
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    [SVProgressHUD showErrorWithStatus:@"保存失败！"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"保存失败！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                NSLog(@"%@", error);
            }];
        });
    }
}

- (NSDictionary *)combineParamsForUpdateHomework {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_homeworkId forKey:@"homeworkId"];
    [dict setObject:_titleTextField.text forKey:@"homeworkTitle"];
    [dict setObject:_detailTextView.text forKey:@"homeworkDetail"];
    return dict.copy;
}

- (void)changeTextViewHight:(CGFloat)height {
    [_detailTextView setFrame:CGRectMake(16, 96, kScreenWidth-32, height)];
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

#pragma mark - Keyboard
- (void)keyboarWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //更改TextView高度
    WEAKSELF
    [UIView animateWithDuration:animationDuration animations:^{
        [weakSelf changeTextViewHight:kScreenHeight-96-40-64-keyboardFrame.size.height];
    }];
    _rightBarBtn.title = @"完成";
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //键盘弹出时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //更改TextView高度
    WEAKSELF
    [UIView animateWithDuration:animationDuration animations:^{
        [weakSelf changeTextViewHight:kScreenHeight-96-40-64];
    }];
    _rightBarBtn.title = @"保存";
}

@end
