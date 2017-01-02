//
//  HKNavigationController.m
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "HKNavigationController.h"

//导航栏颜色
#define NavBarColor [UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HKNavigationController ()

@end

@implementation HKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)load {
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil ];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    [bar setBarTintColor:NavBarColor];
    [bar setTitleTextAttributes:attributes];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    return [super pushViewController:viewController animated:animated];
}

@end
