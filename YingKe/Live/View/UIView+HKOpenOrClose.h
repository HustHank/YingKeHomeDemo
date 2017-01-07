//
//  UIView+HKExtension.h
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKMovingViewPostion) {
    ///NavBar
    HKMovingViewPostionTop,
    ///TabBar
    HKMovingViewPostionBottom,
};

@interface UIView (HKOpenOrClose)

//NavBar or TabBar
@property (nonatomic, assign) HKMovingViewPostion hk_postion;
///需要额外移动的距离
@property (nonatomic, assign) CGFloat hk_extraDistance;

- (CGFloat)hk_updateOffsetY:(CGFloat)deltaY;

- (CGFloat)hk_open;

- (CGFloat)hk_close;

- (BOOL)hk_shouldOpen;

@end
