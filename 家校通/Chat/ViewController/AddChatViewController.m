//
//  AddChatViewController.m
//  家校通
//
//  Created by Sunny on 5/1/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "AddChatViewController.h"
#import "ChatViewController.h"

@interface AddChatViewController () {
    UITextField *_chatIdField;
    UIBarButtonItem *_chatBtn;
}

@end

@implementation AddChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRef(240, 240, 240);
    _chatIdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 44)];
    _chatIdField.backgroundColor = [UIColor whiteColor];
    [_chatIdField setPlaceholder:@"联系人账号"];
    [self.view addSubview:_chatIdField];
    _chatBtn = [[UIBarButtonItem alloc] initWithTitle:@"聊天  " style:UIBarButtonItemStylePlain target:self action:@selector(startChat)];
    self.navigationItem.rightBarButtonItem = _chatBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startChat {
    if (![_chatIdField.text isEqualToString:@""]) {
        ChatViewController *conversationVC = [ChatViewController new];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = _chatIdField.text;
        conversationVC.title = _chatIdField.text;
        [self.navigationController pushViewController:conversationVC animated:YES];
    } else {
        TKAlertViewController *emptyAlert = [[TKAlertViewController alloc] initWithTitle:@"请输入联系人账号！" message:nil];
        [emptyAlert addButtonWithTitle:@"确定" block:^(NSUInteger index) {
            [_chatIdField becomeFirstResponder];
        }];
        [emptyAlert show];
        [_chatIdField resignFirstResponder];
    }
}

@end
