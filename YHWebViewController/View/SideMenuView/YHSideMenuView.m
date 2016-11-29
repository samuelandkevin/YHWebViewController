//
//  YHSideMenuView.m
//  PikeWay
//
//  Created by YHIOS002 on 16/11/23.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHSideMenuView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define SideMenuW SCREEN_WIDTH*0.8

@interface YHSideMenuView()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,copy) SelIndexBlock block;
@property(nonatomic,strong) JSContext *jsContext;
@property(nonatomic,copy) void(^fLoadBlock)(BOOL success,id obj);

@end

@implementation YHSideMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setup];
        
    }
    return self;
}

- (void)setup{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [RGBCOLOR(151, 151, 151) colorWithAlphaComponent:0.7];
    UITapGestureRecognizer *tapBgView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBgView];
    bgView.hidden = YES;
    [self addSubview:bgView];
    _bgView = bgView;
    
    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    webView.backgroundColor =  [UIColor colorWithWhite:0.957 alpha:1.000];
    webView.scrollView.bounces = NO;
    [self addSubview:webView];
    
    _webView = webView;
    _bgView.frame  = self.frame;
    _webView.frame = CGRectMake(-SideMenuW, 0, SideMenuW, SCREEN_HEIGHT);
    
    [self reload];
    
    
    
    
    
   
}


#pragma mark - Gesture
- (void)tapBgView:(UITapGestureRecognizer *)gesture{
    [self hide];
    if (_block) {
        _block(nil,YES);
    }
}


#pragma mark - Public
- (void)show{
    
    self.hidden = NO;
    _bgView.hidden = NO;
    
    WeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.webView.transform = CGAffineTransformTranslate(weakSelf.webView.transform, SideMenuW, 0);
    }];

}

- (void)hide{
    
    WeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.webView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
    self.bgView.hidden = YES;
}

- (void)dismissHandler:(SelIndexBlock)handler{
    _block = handler;
}

//重新加载侧边栏
- (void)reload{
//    NSString *path = [NSString stringWithFormat:@"%@/taxtao/index_left?accessToken=%@",kBaseURL,@""];
    
     NSString *path = @"https://www.baidu.com";
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [_webView loadRequest:req];
}

//第一次加载侧边栏回调
- (void)firstLoadComplete:(void(^)(BOOL suceess,id obj))complete{
    _fLoadBlock = complete;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString rangeOfString:@"www.baidu.com"].location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.loadFail  = NO;
    self.isFirstLoaded = NO;
    if (self.fLoadBlock) {
        self.fLoadBlock(YES,nil);
    }
    
    
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    WeakSelf
    //其他按钮
    self.jsContext[JSName_SM_Other] = ^(){
        NSLog(JSName_SM_Other);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            path = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];;
            NSURL *url = [NSURL URLWithString:path];
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf hide];
                 weakSelf.block(@{@"url":url,
                                  @"name":JSName_SM_Other  },NO);
                
            });
            
        }
    };
    
    //店铺
    self.jsContext[JSName_SM_Store] = ^(){
        NSLog(JSName_SM_Store);
        
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            path = [NSString stringWithFormat:@"%@?accessToken=%@&userId=%@",path,@"",@""];
            
            NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                 @"name":JSName_SM_Store  },NO);
            });
            
        }
    };
    
    //案例
    self.jsContext[JSName_SM_Case] = ^() {
        NSLog(JSName_SM_Case);
        
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            path = [NSString stringWithFormat:@"%@?accessToken=%@&userId=%@",path,@"",@""];
            
            NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_Case  },NO);
            });
            
        }
    };
    
    //资讯
    self.jsContext[JSName_SM_NewsHome] = ^() {
        NSLog(JSName_SM_NewsHome);
        
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            NSURL *url = [NSURL URLWithString:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_NewsHome  },NO);
               
            });
            
        }
        
    };
    
    //悬赏
    self.jsContext[JSName_SM_Reward] = ^() {
        NSLog(JSName_SM_Reward);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            path = [NSString stringWithFormat:@"%@?accessToken=%@&userId=%@",path,@"",@""];
            NSURL *url = [NSURL URLWithString:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                 @"name":JSName_SM_Reward  },NO);
                
            });
            
        }

    };
    
    //人才服务
    self.jsContext[JSName_SM_Talent] = ^() {
        NSLog(JSName_SM_Talent);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            NSURL *url = [NSURL URLWithString:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_Talent  },NO);
            });
            
        }

    };
    
    //热门人才
    self.jsContext[JSName_SM_HotTalent] = ^(){
        NSLog(JSName_SM_HotTalent);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            NSURL *url = [NSURL URLWithString:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_HotTalent  },NO);
            });
            
        }
    };
    
    //大咖
    self.jsContext[JSName_SM_Daka] = ^(){
        NSLog(JSName_SM_Daka);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            
            //返回的字符串
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *path = [value toString];
            
            //1.dakaBasePath参数在筛选大咖页面必要
            NSString *dakaBasePath = nil;
            NSRange range = [path rangeOfString:@"&industry=all"];
            NSRange range2 = [path rangeOfString:@"&industry=industry"];
            if (range.location != NSNotFound) {
                dakaBasePath = [path substringToIndex:range.location];
                dakaBasePath = [NSString stringWithFormat:@"%@accessToken=%@&userId=%@",dakaBasePath,@"",@""];
            }else if(range2.location != NSNotFound){
                dakaBasePath = [path substringToIndex:range2.location];
                dakaBasePath = [NSString stringWithFormat:@"%@accessToken=%@&userId=%@",dakaBasePath,@"",@""];
            }else{
                dakaBasePath = @"";
            }
            
            //2.获取全部大咖列表urlstring.
            path = [NSString stringWithFormat:@"%@&accessToken=%@&userId=%@",path,@"",@""];
            NSURL *url = [NSURL URLWithString:path];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_Daka,
                                 @"dakaBasePath":dakaBasePath},NO);
                
            });
            
        }
        
    };
    
    //大咖更多
    self.jsContext[JSName_SM_MoreDaka] = ^(){
        NSLog(JSName_SM_MoreDaka);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            
            //返回的字符串
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *urlString = [value toString];
            
            urlString = [NSString stringWithFormat:@"%@/taxtao%@?&accessToken=%@&userId=%@",kBaseURL,urlString,@"",@""];
            NSURL *url = [NSURL URLWithString:urlString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hide];
                weakSelf.block(@{@"url":url,
                                     @"name":JSName_SM_MoreDaka  },NO);
                
            });
            
        }
    };
    
    
    //横幅
    self.jsContext[JSName_SM_Banner] = ^(){
        NSLog(JSName_SM_Banner);
        NSArray *args = [JSContext currentArguments];
        if (args.count && args) {
            JSValue *value = args[0];
            NSLog(@"%@",[value toString]);
            NSString *urlString = [value toString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            });
        }
          
    };
    
    //其他按钮
//    self.jsContext[@"onCallIosHomePage"] = ^(){
//        NSLog(@"onCallBuilding");
//        
//        NSArray *args = [JSContext currentArguments];
//        if (args.count && args) {
//            JSValue *value = args[0];
//            ;
//            NSString *path = [NSString stringWithFormat:@"/%@",[value toString]];
//            path = [kBaseURL stringByAppendingString:path];
//            NSURL *url = [NSURL URLWithString:path];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.block(url,NO);
//                [weakSelf hide];
//            });
//            
//        }
//        
//    };


    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.loadFail = YES;
    if (self.fLoadBlock) {
         self.fLoadBlock(NO,error);
    }
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
