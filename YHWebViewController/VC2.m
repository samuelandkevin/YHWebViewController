//
//  VC2.m
//  YHWebViewController
//
//  Created by YHIOS002 on 16/11/29.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "VC2.h"
#import "YHSharePresentView.h"

@interface VC2 ()
@property (nonatomic,strong) NSDictionary *shareNews;
@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Super
- (void)setUpNavigationBar{
    [super setUpNavigationBar];
    
    //右barItem
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnRight setImage:[UIImage imageNamed:@"workgroup_img_more.png"] forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [btnRight addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = editBtn;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    
    //图片地址
    NSString *picUrl = [webView stringByEvaluatingJavaScriptFromString:@" document.querySelector('.pic img').src"];
    //下载图片
//    UIImageView *imageV = [[UIImageView alloc] init];
//    [imageV sd_setImageWithURL:[NSURL URLWithString:picUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    //标题
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@" document.querySelector('.title').innerHTML"] ;
    
    if (!self.url) {
        self.url = [NSURL URLWithString:@""];
    }
    if (!picUrl.length) {
        picUrl = @"";
    }
    if (!title.length) {
        title = @"";
    }
    
    //设置分享内容
    _shareNews = @{
                   @"title":title,
                   @"picUrl":picUrl,
                   @"url":[self.url absoluteString]
                   };
}

#pragma mark - Action
- (void)onRight:(id)sender{
    NSLog(@"%@",self.url);
    [self showShareView];
}


- (void)showShareView{
    YHSharePresentView *shareView = [[YHSharePresentView alloc] init];
    shareView.shareType = ShareType_News;
    [shareView show];
    [shareView dismissHandler:^(BOOL isCanceled, NSInteger index) {
        if(!isCanceled){
            
            switch (index) {
                case 0:
                {
                    //QQ

                    
                }
                    break;
                case 1:
                {
                    //朋友圈
                    
                }
                    break;
                    
                case 2:
                {
                    //微信好友

                }
                    break;
                case 3:
                {
                    
                }
                    break;
                default:
                    break;
            }
            
        }
        
    }];
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
