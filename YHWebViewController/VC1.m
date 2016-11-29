//
//  ViewController.m
//  YHWebViewController
//
//  Created by YHIOS002 on 16/11/29.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "VC1.h"
#import "VC2.h"
#import "YHSideMenuView.h"

@interface VC1 ()<UIScrollViewDelegate>
@property (nonatomic, strong) YHSideMenuView *sMenu;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Super
- (void)setUpNavigationBar{
    
    self.title = @"资讯";
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 21, 21);
    [leftBtn setImage:[UIImage imageNamed:@"home_img_sideMenu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(onLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
}

- (void)setUpWebView{
    //    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    self.webView.multipleTouchEnabled = NO;
    self.webView.scrollView.bouncesZoom = NO;
    self.webView.scrollView.delegate = self;
    
    NSString *path = @"http://testapp.gtax.cn/tax/sd/ygz";

    self.url = [NSURL URLWithString:path];
    NSMutableURLRequest *mreq = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:mreq];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}


- (void)setUpUserAgent{
    [super setUpUserAgent];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [super webViewDidFinishLoad:webView];
    
    WeakSelf
    //点击全文
    self.jsContext[@"onCallHomePageNewsDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [NSURL URLWithString:path];
                VC2 *vc = [[VC2 alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) url:url];
                vc.title = @"详情";
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }
    };

    
}


#pragma mark - Lazy Load
//侧边菜单栏
- (YHSideMenuView *)sMenu{
    if (!_sMenu) {
        _sMenu = [YHSideMenuView new];
        _sMenu.isFirstLoaded = YES;
        _sMenu.tag = 1112;
        WeakSelf
        [_sMenu dismissHandler:^(NSDictionary *userInfo, BOOL isCancel) {
            if (!isCancel) {
                [weakSelf handleSideMenuWithDict:userInfo];
            }
        }];
    }
    
    YHSideMenuView *sideMenu = [[self statusBarWindow] viewWithTag:1112];
    if (!_sMenu.isFirstLoaded && !sideMenu) {
        [[self statusBarWindow] addSubview:_sMenu];
    }
    return _sMenu;
}

//点击侧边菜单某一项 (切换到相应的VC)
- (void)handleSideMenuWithDict:(NSDictionary*)dict{
    
}


#pragma mark - Action
//打开侧边栏
- (void)onLeft:(id)sender{
    
    //侧边栏第一次加载,显示Loading
    if (self.sMenu.isFirstLoaded) {
        
        if (![self.view viewWithTag:11111]) {
            WeakSelf
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.tag = 11111;
            [self.sMenu firstLoadComplete:^(BOOL suceess, id obj) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (suceess) {
                    
                    [[self statusBarWindow] addSubview:_sMenu];
                    [weakSelf.sMenu show];
                }
                
            }];
        }
        
    }else{
        [self.sMenu show];
    }
    
    if (self.sMenu.loadFail) {
        [self.sMenu reload];
    }
}

//点击搜索
- (void)onSearch:(UIBarButtonItem *)sender{

    
}

#pragma mark - Private
- (UIWindow *)statusBarWindow
{
    return [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
