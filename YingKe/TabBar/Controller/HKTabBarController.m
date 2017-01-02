//
//  HKTabBarController.m
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "HKTabBarController.h"
#import "HKNavigationController.h"
#import "HKLiveTableViewController.h"
#import "HKMineViewController.h"
#import "HKCreateRoomViewController.h"

#import "HKTabBar.h"

@interface HKTabBarController () <HKTabBarDelegate>

@end

@implementation HKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildVc];
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    HKTabBar *tabbar = [[HKTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc {
    HKLiveTableViewController *liveVc = [[HKLiveTableViewController alloc] init];
    [self setupOneChildVcWithVc:liveVc image:@"tab_live" selectedImage:@"tab_live_p" title:@"首页"];
    
    HKMineViewController *mineVc = [[HKMineViewController alloc] init];
    [self setupOneChildVcWithVc:mineVc image:@"tab_me" selectedImage:@"tab_me_p" title:@"我的"];
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

- (void)setupOneChildVcWithVc:(UIViewController *)Vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    
    HKNavigationController *nav = [[HKNavigationController alloc] initWithRootViewController:Vc];
//    nav.hidesBarsOnSwipe = YES;
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;

    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    Vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    
    [self addChildViewController:nav];
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(HKTabBar *)tabBar {

    HKCreateRoomViewController *plusVC = [[HKCreateRoomViewController alloc] init];
    plusVC.view.backgroundColor = [UIColor whiteColor];
    [self.selectedViewController pushViewController:plusVC animated:YES];
}

@end
