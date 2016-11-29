//
//  YHSideMenuView.h
//  PikeWay
//
//  Created by YHIOS002 on 16/11/23.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//SM:sideMenu 侧边栏菜单

#define JSName_SM_NewsHome @"onCallIosHomePageNews"//资讯首页
#define JSName_SM_Case @"onCallExampleCase" //案例
#define JSName_SM_Talent @"onCallTalented" //人才
#define JSName_SM_HotTalent @"onCallIosHotTalent" //热门人才
#define JSName_SM_Other @"onCallIosHomePage" //正在建设中
#define JSName_SM_Daka @"onCallBigKa" //大咖
#define JSName_SM_MoreDaka @"onCallMoreDaKa" //更多大咖
#define JSName_SM_Store @"onCallStore" //店铺
#define JSName_SM_Reward @"onCallRewardModule" //悬赏
#define JSName_SM_Banner @"onCallIosRollImg" //横幅


typedef void(^SelIndexBlock)(NSDictionary *userInfo,BOOL isCancel);

@interface YHSideMenuView : UIView

@property (nonatomic,assign) BOOL loadFail;//加载失败
@property (nonatomic,assign) BOOL isFirstLoaded;//第一次加载


- (void)dismissHandler:(SelIndexBlock)handler;
- (void)show;
- (void)hide;
- (void)reload;//重新加载侧边栏网页

//第一次加载侧边栏回调
- (void)firstLoadComplete:(void(^)(BOOL suceess,id obj))complete;
@end
