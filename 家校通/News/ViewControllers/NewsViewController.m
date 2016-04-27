//
//  NewsViewController.m
//  家校通
//
//  Created by Sunny on 2/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController () <UIWebViewDelegate> {
    UIWebView *_webView;
    UIActivityIndicatorView *_indicator;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新闻承载页面
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    //返回新闻列表按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(loadWebView)];
    
    //延迟显示状态栏
    [self delayShowStatusBar];
    
    //加载 web view
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Function
//有菊花旋转的加载网页
- (void)loadWebView {
    //打开指定的html网页呈现新闻
    NSURL *pathURL = [NSURL URLWithString:@"http://zesicus.site"];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathURL];
    [_webView loadRequest:request];
    //加载前菊花
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setCenter:CGPointMake(20, 20)];
    [self.view addSubview:_indicator];
    [_indicator setHidesWhenStopped:YES];
    [_indicator startAnimating];
}

#pragma mark - UIWebViewDelegate implement
//加载网页完毕菊花消失
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicator stopAnimating];
}

#pragma mark - Status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return _isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)delayShowStatusBar {
    if (_isStatusBarHidden) {
        //等待Launch动画结束，动态滑入状态栏，NavigationController下也很自然
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isStatusBarHidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf setNeedsStatusBarAppearanceUpdate];
            }];
        });
    }
}

@end
