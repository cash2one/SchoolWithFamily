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

@interface HomeworkTableViewController () {
    NSArray *_dataArr;
}

@end

@implementation HomeworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHomework];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addPullToRefresh];
}

#pragma mark - Function
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
        _dataArr = model.data;
        [self.tableView reloadData];
    } orFailure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"取作业列表失败！/n%@", error);
    }];
}

- (void)loadHomeworkByUser:(NSString *)username {
    NSDictionary *dict = [self combineParamsLoadHomeworkByUser:username];
    [[NetworkManager sharedManager] requestByPostWithUrl:@"http://zesicus.site/interface/school_manager/homework_manage/showHomeworkByUserId.php" andDict:dict finishWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        Homework *model = [[Homework alloc] initWithDictionary:responseObject error:nil];
        _dataArr = model.data;
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
    detailVC.homeworkTitle = ((HomeworkData *)_dataArr[indexPath.row]).homeworkTitle;
    detailVC.uploader = ((HomeworkData *)_dataArr[indexPath.row]).userId;
    detailVC.homeworkDetail = ((HomeworkData *)_dataArr[indexPath.row]).homeworkDetail;
    detailVC.uploadDate = ((HomeworkData *)_dataArr[indexPath.row]).homeworkDate;
    detailVC.score = ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore?[NSString stringWithFormat:@"分数：%@", ((HomeworkData *)_dataArr[indexPath.row]).homeworkScore]:unmarked;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
