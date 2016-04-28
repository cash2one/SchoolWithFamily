//
//  HomeworkTableViewController.m
//  家校通
//
//  Created by Sunny on 4/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "HomeworkTableViewController.h"
#import "HomeworkCell.h"
#import "HomeworkDetailViewController.h"
#import "Homework.h"
#import "DeleteHomework.h"

@interface HomeworkTableViewController () {
    NSMutableArray *_dataArr;
}

@property (nonatomic, strong) JRMessageView *successMsg;
@property (nonatomic, strong) JRMessageView *failureMsg;

@end

@implementation HomeworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self configJRMessageView];
    [self addPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self loadHomework];
}

#pragma mark - Function
- (void)configJRMessageView {
    self.successMsg = [[JRMessageView alloc] initWithTitle:@"删除成功"
                                                subTitle:nil
                                                iconName:@"11"
                                             messageType:JRMessageViewTypeSuccess
                                         messagePosition:JRMessagePositionNavBarOverlay
                                                 superVC:self
                                                duration:1.5];
    self.failureMsg = [[JRMessageView alloc] initWithTitle:@"删除失败"
                                                  subTitle:nil
                                                  iconName:@"请检查网络设置"
                                               messageType:JRMessageViewTypeSuccess
                                           messagePosition:JRMessagePositionNavBarOverlay
                                                   superVC:self
                                                  duration:2];
}

- (void)addPullToRefresh {
    WEAKSELF
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        [weakSelf loadHomework];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView stopLoading];
        });
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:kCommonColor];
    [self.tableView setJElasticPullToRefreshBackgroundColor:[UIColor whiteColor]];
}

- (void)loadHomework {
    if ([[userDefaults objectForKey:keyUserType] isEqualToString:@"2"]) {
        [self loadHomeworkByUser:[userDefaults objectForKey:keyUsername]];
    } else {
        [self loadHomeworkAll];
    }
}

- (void)loadHomeworkAll {
    [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/showHomework.php" andDict:nil finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        Homework *model = [[Homework alloc] initWithDictionary:responseObject error:nil];
        _dataArr = [NSMutableArray arrayWithArray:model.data];
        [self.tableView reloadData];
    } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"取作业列表失败！/n%@", error);
    }];
}

- (void)loadHomeworkByUser:(NSString *)username {
    NSDictionary *dict = [self combineParamsLoadHomeworkByUser:username];
    [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/showHomeworkByUserId.php" andDict:dict finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        Homework *model = [[Homework alloc] initWithDictionary:responseObject error:nil];
        [_dataArr removeAllObjects];
        _dataArr = [NSMutableArray arrayWithArray:model.data];
        [self.tableView reloadData];
    } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"取作业列表失败！/n%@", error);
    }];
}

- (NSDictionary *)combineParamsLoadHomeworkByUser:(NSString *)username {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:username forKey:@"userId"];
    return dict.copy;
}

- (NSDictionary *)combineParamsForDeleteHomeworkById:(NSString *)homeworkId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:homeworkId forKey:@"homeworkId"];
    return dict.copy;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"HomeworkCell";
    HomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"HomeworkCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.titleLabel.text = ((HomeworkData *)_dataArr[indexPath.row]).homeworkTitle;
    cell.detailLabel.text = ((HomeworkData *)_dataArr[indexPath.row]).homeworkDetail;
    cell.uploaderLabel.text = ((HomeworkData *)_dataArr[indexPath.row]).userId;
    cell.scoreLabel.text = ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore?[NSString stringWithFormat:@"分数：%@", ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore]:unmarked;
    
    if ([cell.scoreLabel.text isEqualToString:unmarked]) {
        cell.scoreLabel.textColor = [UIColor grayColor];
    } else {
        cell.scoreLabel.textColor = [UIColor redColor];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkDetailViewController *detailVC = [HomeworkDetailViewController new];
    detailVC.homeworkId = ((HomeworkData *)_dataArr[indexPath.row]).homeworkId;
    detailVC.homeworkTitle = ((HomeworkData *)_dataArr[indexPath.row]).homeworkTitle;
    detailVC.uploader = ((HomeworkData *)_dataArr[indexPath.row]).userId;
    detailVC.homeworkDetail = ((HomeworkData *)_dataArr[indexPath.row]).homeworkDetail;
    detailVC.uploadDate = ((HomeworkData *)_dataArr[indexPath.row]).homeworkDate;
    detailVC.score = ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore?[NSString stringWithFormat:@"分数：%@", ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore]:unmarked;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.scoreLabel.text isEqualToString:unmarked] && [[userDefaults objectForKey:keyUserType] isEqualToString:@"2"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[userDefaults objectForKey:keyUserType] isEqualToString:@"2"]) {
            NSDictionary *dict = [self combineParamsForDeleteHomeworkById:((HomeworkData *)_dataArr[indexPath.row]).homeworkId];
            WEAKSELF
            [JCAlertView showTwoButtonsWithTitle:@"警告❗️" Message:@"确认删除该作业吗？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
                [weakSelf.tableView reloadData];
            } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
                [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/deleteHomework.php" andDict:dict finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    DeleteHomework *model = [[DeleteHomework alloc] initWithDictionary:responseObject error:nil];
                    if ([model.responseCode isEqualToString:@"100"]) {
                        [_dataArr removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView reloadData];
                    }
                    [_successMsg showMessageView];
                } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    [_failureMsg showMessageView];
                }];
            }];
        }
    }
}

@end
