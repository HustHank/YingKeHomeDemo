//
//  HKTabBar.m
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "HKTabBar.h"

#import "UIView+HKExtension.h"

static CGFloat kMargin = 5.f;

@interface HKTabBar ()

/** 中间按钮 */
@property (nonatomic, weak) UIButton *centerBtn;
@property (nonatomic, copy) HKTabBarClickBlock block;

@end

@implementation HKTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        //去掉TabBar的分割线
        [self setBackgroundImage:[UIImage new]];
        [self setShadowImage:[UIImage new]];
        //设置中间按钮图片和尺寸
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(centerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.centerBtn = plusBtn;
        [self addSubview:plusBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    
    self.centerBtn.centerX = self.centerX;
    //调整中间按钮的中线点Y值
    self.centerBtn.centerY = self.height * 0.5 - 2 * kMargin ;
    
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //按钮宽度为TabBar宽度减去中间按钮宽度的一半
            btn.width = (self.width - self.centerBtn.width) * 0.5;
            
            if (btnIndex < 1) {
                btn.x = btn.width * btnIndex;
            } else {
                btn.x = btn.width * btnIndex + self.centerBtn.width;
            }
            
            btnIndex++;
            //如果是索引是0(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来中间按钮的位置
            if (btnIndex == 0) {
                btnIndex++;
            }
        }
    }
    
    [self bringSubviewToFront:self.centerBtn];
}

#pragma mark - Btn Click
- (void)centerBtnDidClick {
    if (self.block) {
        self.block();
    }
}

- (void)setBtnClickBlock:(HKTabBarClickBlock)block {
    self.block = block;
}

//重写hitTest方法，去监听中间按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //判断当前手指是否点击到中间按钮上，如果是，则响应按钮点击，其他则系统处理
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
