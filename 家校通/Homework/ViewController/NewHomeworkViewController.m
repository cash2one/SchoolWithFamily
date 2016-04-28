//
//  NewHomeworkViewController.m
//  家校通
//
//  Created by Sunny on 4/28/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "NewHomeworkViewController.h"
#import "CommitHomework.h"

@interface NewHomeworkViewController ()

@property (nonatomic, strong) UITextField *titleTxtField;
@property (nonatomic, strong) UITextView *detailTxtView;

@end

@implementation NewHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRef(240, 240, 240);
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [defaultNotiCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Function

- (void)configView {
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存  " style:UIBarButtonItemStylePlain target:self action:@selector(saveHomework)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    _titleTxtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [_titleTxtField setFont:[UIFont systemFontOfSize:20]];
    [_titleTxtField setBackgroundColor:[UIColor whiteColor]];
    [_titleTxtField setPlaceholder:@"标题"];
    [_titleTxtField setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_titleTxtField];
    
    _detailTxtView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleTxtField.frame) + 15, kScreenWidth, kScreenHeight-CGRectGetMaxY(_titleTxtField.frame)-30-49-64)];
    [_detailTxtView setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_detailTxtView];
}

- (void)saveHomework {
    [_titleTxtField resignFirstResponder];
    [_detailTxtView resignFirstResponder];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"保存中..."];
    WEAKSELF
    [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/submitHomework.php" andDict:[weakSelf combineParamSaveHomework] finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        CommitHomework *model = [[CommitHomework alloc] initWithDictionary:responseObject error:nil];
        if ([model.responseCode isEqualToString:@"100"]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSLog(@"%@", error);
    }];
}

- (NSDictionary *)combineParamSaveHomework {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_titleTxtField.text forKey:@"homeworkTitle"];
    [dict setObject:_detailTxtView.text forKey:@"homeworkDetail"];
    [dict setObject:[userDefaults objectForKey:keyUsername] forKey:@"userId"];
    return dict.copy;
}

- (void)changeTextViewHight:(CGFloat)height {
    [_detailTxtView setFrame:CGRectMake(0, CGRectGetMaxY(_titleTxtField.frame) + 15, kScreenWidth, height)];
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
        [weakSelf changeTextViewHight:kScreenHeight-CGRectGetMaxY(_titleTxtField.frame)-49-64-keyboardFrame.size.height];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //键盘弹出时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //更改TextView高度
    WEAKSELF
    [UIView animateWithDuration:animationDuration animations:^{
        [weakSelf changeTextViewHight:kScreenHeight-CGRectGetMaxY(_titleTxtField.frame)-30-49-64];
    }];
}

@end
