//
//  HKTabBar.h
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTabBar;

@protocol HKTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(HKTabBar *)tabBar;
@end


@interface HKTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<HKTabBarDelegate> myDelegate;

@end
