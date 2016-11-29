//
//  YHWebViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/6/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHWebViewController.h"


@interface YHWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) CGRect rect;

//控件
@property (nonatomic,strong) UIButton   *btnScrollToTop;
@property (nonatomic,strong) YHLoadView *viewLoadFail;
@property (nonatomic,strong) YHLoadView *viewLoading;

//标志变量
@property (nonatomic,assign)  BOOL hasRegisterKeyboardNotification;
@property (nonatomic,assign)  BOOL        keyboardIsShown;
@end

@implementation YHWebViewController

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url{
    if (self  = [super init]) {
        _url  = url;
        _rect = frame;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url{
    if(self = [super init]){
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}

- (void)setUpNavigationBar{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 40, 40);
    //    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"leftarrow"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}

- (void)setUpUserAgent{
    UIWebView *tempWebV = [[UIWebView alloc] init];
    NSString *sAgent = [tempWebV stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *userAgent = [NSString stringWithFormat:@"%@; ShuiDao /%f",sAgent,2.0];
    [tempWebV stringByEvaluatingJavaScriptFromString:userAgent];
    NSDictionary*dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)setUpWebView{
    _webView.frame = _rect;
    
    NSMutableURLRequest *mreq = [NSMutableURLRequest requestWithURL:_url];
    [_webView loadRequest:mreq];
}

- (void)initUI{
    

    [self setUpNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    
    //1.webview
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.opaque   = NO;
    [_webView setScalesPageToFit:YES];
    _webView.scrollView.delegate = self;

    
    
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    [self setUpWebView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor colorWithWhite:0.957 alpha:1.000];
    
}

#pragma mark - Lazy Load
- (YHLoadView *)viewLoading{
    if (!_viewLoading) {
        _viewLoading = [YHLoadView loading];
        _viewLoading.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT/4);
        [self.view addSubview:_viewLoading];
    }
    return _viewLoading;
}

- (YHLoadView *)viewLoadFail{
    if(!_viewLoadFail){
        _viewLoadFail = [YHLoadView loadFail];
        _viewLoadFail.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT/4);
        WeakSelf
        [_viewLoadFail onReloadHandler:^{
            NSLog(@"onReload");
            NSMutableURLRequest *mreq = [NSMutableURLRequest requestWithURL:weakSelf.url];
            [weakSelf.webView loadRequest:mreq];
        }];
        [self.view addSubview:_viewLoadFail];
    }
    return _viewLoadFail;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

#pragma mark - Action
- (void)onBack:(id)sender{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
        if(_presentedVC){
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Life
- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = self.navigationBarHidden;
    if (self.navigationBarHidden) {
        //状态栏背景添加
        if (![self.view viewWithTag:1111]) {
            UIView *statusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            statusBarBG.tag = 1111;
            statusBarBG.backgroundColor = [UIColor colorWithRed:0.f green:191.f / 255 blue:143.f / 255 alpha:1];
            [self.view addSubview:statusBarBG];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
}

- (void)dealloc{
    self.webView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)registerForKeyboardNotifications {
    if (_hasRegisterKeyboardNotification) {//注册的键盘通知，直接退出
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    _hasRegisterKeyboardNotification = YES;
}

- (void)unregisterKeyboardNotifications {
    if (!_hasRegisterKeyboardNotification) {
        return;
    }
    _hasRegisterKeyboardNotification = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjustScrollView:keyboardRect];
    
}


- (void)adjustScrollView:(CGRect)kbRect {

    WeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.webView.scrollView.contentOffset = CGPointMake(0, kbRect.size.height);
    }];

}




#pragma mark - UIWebViewDelegate

//网页开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
    [self.viewLoading showLoadingView];
    [self.viewLoadFail hideFailView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.viewLoading hideLoadingView];
    [self.viewLoadFail hideFailView];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if (self.navigationBarHidden) {
        //状态栏背景移除
        UIView *statusBarBG = [self.view viewWithTag:1111];
        [statusBarBG removeFromSuperview];
    }
    
    
    [self.viewLoading hideLoadingView];
    
    if (error.code == 102){
        //链接无效,不做任何跳转
        
    }else{
        if ([error.userInfo[@"cache"] boolValue] == NO) {
            NSLog(@"no HTML cache");
            //没缓存,显示失败View,点击可重新加载
            [self.viewLoadFail showLoadFailView];
        }
    }
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   [self scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll{

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
