//
//  ChooseGroupViewController.m
//  家校通
//
//  Created by Sunny on 5/2/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "ChooseGroupViewController.h"

@interface ChooseGroupViewController ()

@end

@implementation ChooseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRef(240, 240, 240);
    self.navigationItem.title = @"请选择用户组";
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view
- (void)configTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 132)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identi = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"教师";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"学生";
    } else {
        cell.textLabel.text = @"家长";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [defaultNotiCenter postNotificationName:Noti_ChooseGroup object:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
