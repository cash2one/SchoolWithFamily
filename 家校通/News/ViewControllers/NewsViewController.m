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
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //新闻承载页面
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    //返回新闻列表按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(loadWebView)];
    
    [self loadWebView];
}

//有菊花旋转的加载网页
- (void)loadWebView {
    //打开指定的html网页呈现新闻
    NSURL *pathURL = [NSURL URLWithString:@"http://zesicus.site"];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathURL];
    [_webView loadRequest:request];
    //加载前菊花
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setCenter:CGPointMake(20, 84)];
    [self.view addSubview:_indicator];
    [_indicator setHidesWhenStopped:YES];
    [_indicator startAnimating];
}

#pragma mark - UIWebViewDelegate implement
//加载网页完毕菊花消失
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicator stopAnimating];
}

@end
