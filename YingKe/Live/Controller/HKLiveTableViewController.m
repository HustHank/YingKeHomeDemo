//
//  HKLiveTableViewController.m
//  YinKe
//
//  Created by HK on 17/1/2.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKLiveTableViewController.h"
#import "HKCreateRoomViewController.h"
#import "UIView+HKOpenOrClose.h"

static NSString * const kCellIdentifier = @"HKLiveTableViewCellIdentifier";
static CGFloat kStatusBarHeight = 20.f;
static CGFloat kNavBarHeight = 44.f;
//中间按钮超出TabBar的距离，根据实际情况来定
static CGFloat kTabBarCenterButtonDelta = 44.f;

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HKLiveTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) CGFloat previousOffsetY;

@end

@implementation HKLiveTableViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self open];
}

#pragma mark - Init
- (void)commonInit {
    
    _previousOffsetY = 0;
    
    [self initTableView];
    [self initDataSource];
    [self initTabBar];
}

- (void)initTableView {
    self.tableView.backgroundColor = [UIColor blueColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)initDataSource {
    self.dataSource = @[].mutableCopy;
    for (NSInteger index = 0; index < 50; index++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"UITableViewCell---section_0---row_%ld",(long)index]];
    }
}

- (void)initTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    tabBar.hk_postion = HKMovingViewPostionBottom;
    tabBar.hk_extraDistance = kTabBarCenterButtonDelta;
}

#pragma mark - Private Method

- (void)open {
    [self.navigationController.navigationBar hk_open];
    [self.tabBarController.tabBar hk_open];
}

- (void)close {
    [self.navigationController.navigationBar hk_close];
    [self.tabBarController.tabBar hk_close];
}

- (void)updateScrollViewInset {
    CGFloat navBarMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat tabBarMinY = CGRectGetMinY(self.tabBarController.tabBar.frame);
    UIEdgeInsets scrollViewInset = self.tableView.contentInset;
    scrollViewInset.top = [self adjustTopInset:navBarMaxY];
    scrollViewInset.bottom = [self adjustBottomInset:MAX(0, kScreenHeight - tabBarMinY)];
    self.tableView.contentInset = scrollViewInset;
    self.tableView.scrollIndicatorInsets = scrollViewInset;
}

- (void)closeOrOpenBar {
    //NavBar和TabBar是展开还是收起
    BOOL opening = [self.navigationController.navigationBar hk_shouldOpen];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat navBarOffsetY = 0;
        if (opening) {
            //navBarOffsetY为NavBar从当前位置到展开滑动的距离
            navBarOffsetY = [self.navigationController.navigationBar hk_open];
            [self.tabBarController.tabBar hk_open];
        } else {
            //navBarOffsetY为NavBar从当前位置到收起滑动的距离
            navBarOffsetY = [self.navigationController.navigationBar hk_close];
            [self.tabBarController.tabBar hk_close];
        }
        //更新TableView的contentInset
        [self updateScrollViewInset];
        //根据NavBar的偏移量来滑动TableView
        CGPoint contentOffset = self.tableView.contentOffset;
        contentOffset.y += navBarOffsetY;
        self.tableView.contentOffset = contentOffset;
    }];
}

- (CGFloat)adjustTopInset:(CGFloat)topInset {
    if (@available(iOS 11.0, *)) {
        return topInset - (self.tableView.adjustedContentInset.top - self.tableView.contentInset.top);
    }
    return topInset;
}

- (CGFloat)adjustBottomInset:(CGFloat)bottomInset {
    if (@available(iOS 11.0, *)) {
        return bottomInset - (self.tableView.adjustedContentInset.bottom - self.tableView.contentInset.bottom);
    }
    return bottomInset;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //在push到其他页面时候，还是会走该方法，这个时候不应该继续执行
    if (!(self.isViewLoaded && self.view.window != nil)) {
        return;
    }
    
    // 1 - 计算偏移量
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat deltaY = contentOffsetY - _previousOffsetY;
    
    // 2 - 忽略超出滑动范围的Offset
    // 1) - 忽略向上滑动的Offset
    CGFloat topInset = kStatusBarHeight + kNavBarHeight;
    CGFloat start = -topInset;
    if (_previousOffsetY <= start) {
        deltaY = MAX(0, deltaY + (_previousOffsetY - start));
    }
    
    // 2) - 忽略向下滑动的Offset
    CGFloat maxContentOffset = scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom;
    CGFloat end = maxContentOffset;
    if (_previousOffsetY >= end) {
        deltaY = MIN(0, deltaY + (_previousOffsetY - maxContentOffset));
    }

    // 3 - 更新navBar和TabBar的frame
    [self.navigationController.navigationBar hk_updateOffsetY:deltaY];
    [self.tabBarController.tabBar hk_updateOffsetY:deltaY];
    
    // 4 - 更新TableView的contentInset
    [self updateScrollViewInset];
    
    // 5 - 保存当前的contentOffsetY
    self.previousOffsetY = contentOffsetY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _previousOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //在拖动停止时，根据当前偏移量，决定当前NavBar和TabBar是收起还是展开
    [self closeOrOpenBar];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKCreateRoomViewController *plusVC = [[HKCreateRoomViewController alloc] init];
    plusVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:plusVC animated:YES];
}

@end
