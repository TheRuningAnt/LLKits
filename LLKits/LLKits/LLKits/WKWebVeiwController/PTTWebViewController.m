//
//  PTTWebViewController.m
//  TestWebView_1102
//
//  Created by 赵广亮 on 2016/11/2.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTWebViewController.h"
#import <WebKit/WebKit.h>

@interface PTTWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong)WKWebView *wkWebView;

@end

@implementation PTTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //添加js回调方法
    [[self.wkWebView configuration].userContentController addScriptMessageHandler:self name:@"shareAction"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self pttSetTitle:self.pttTitle];
    
    //创建wkwebView
    //如果是带导航栏的话 wkWebView的高度应该是屏幕的高度减去导航栏的高度减去状态栏的高度  kWindowHeight -20 -44
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64 + TopSpace, [UIScreen mainScreen].bounds.size.width, kWindowHeight - 64 - TopSpace - BottomSpace)];
    self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.wkWebView.navigationDelegate = self;
    
    //设置网址链接
    if (self.htmlStr) {
        
        [self.wkWebView loadHTMLString:self.htmlStr baseURL:nil];
    }else if (self.pttUrl) {
        
        NSRange range = [self.pttUrl rangeOfString:@"htt"];
        if (range.length == 0) {
            
            self.pttUrl = [NSString stringWithFormat:@"http://%@",self.pttUrl];
        }
        
        NSURL *url = [NSURL URLWithString:self.pttUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.wkWebView loadRequest:request];
    }
    
    
    //添加到页面上去
    [self.view addSubview:self.wkWebView];
}

#pragma wkwebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    [PttLoadingTip startLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        
    }];
    [PttLoadingTip stopLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    [PttLoadingTip stopLoading];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [PttLoadingTip stopLoading];
}

#pragma mark 按钮触发方法
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
