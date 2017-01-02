//
//  HKLiveTableViewController.m
//  YinKe
//
//  Created by HK on 17/1/2.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKLiveTableViewController.h"

static NSString * const kCellIdentifier = @"HKLiveTableViewCellIdentifier";
static CGFloat kStatusBarHeight = 20.f;
static CGFloat kNavbarHeight = 44.f;
static CGFloat kDeltaLimit = 44.f;
static CGFloat kTabBarCenterButtondelta = 44.f;

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HKLiveTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) CGFloat lastContentOffsetY;

@end

@implementation HKLiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor blueColor];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    self.data = @[].mutableCopy;
    for (NSInteger index = 0; index < 50; index++) {
        [self.data addObject:[NSString stringWithFormat:@"UITableViewCell---section_0---row_%ld",(long)index]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //TODO:Recvoery navgationg to next UIViewcontroller
}

#pragma mark - Private Method
- (void)scrollWithDelta:(CGFloat)delta {
    CGRect frameNav = self.navigationController.navigationBar.frame;
    CGRect frameTabBar = self.tabBarController.tabBar.frame;
    CGFloat navDelta = delta;
    CGFloat tabBarDelta = delta;
    CGFloat tabBarDelta1 = delta;
    CGFloat insetTop = self.tableView.contentInset.top;
    CGFloat insetBottom = self.tableView.contentInset.top;
    
    // Scrolling the view up, hiding the navbar and tabbar
    if (delta > 0) {
        
        if (frameNav.origin.y - navDelta < -kDeltaLimit) {
            navDelta = frameNav.origin.y + kDeltaLimit;
        }
        insetTop -= navDelta;
        
        frameNav.origin.y -= navDelta;
        self.navigationController.navigationBar.frame = frameNav;
        
        CGFloat maxTabBarY = kScreenHeight + kTabBarCenterButtondelta;
        
        if (frameTabBar.origin.y + tabBarDelta > maxTabBarY) {
            tabBarDelta = maxTabBarY - frameTabBar.origin.y;
        }
        
        if (frameTabBar.origin.y + tabBarDelta1 > kScreenHeight) {
            tabBarDelta1 = MAX(0, kScreenHeight - frameTabBar.origin.y);
        }
        
        insetBottom -= tabBarDelta1;
        if (0 == tabBarDelta1) {
            insetBottom = 0;
        }
        
        frameTabBar.origin.y += tabBarDelta;
        self.tabBarController.tabBar.frame = frameTabBar;
        
        NSLog(@"delta > 0---navFrameY:%f",frameNav.origin.y);
        NSLog(@"delta > 0---tabBarDelta:%f",tabBarDelta);
        NSLog(@"delta > 0---tabBarDelta1:%f",tabBarDelta1);
        
        [self updateTableViewInsetTop:insetTop andInsetBottom:insetBottom];
    }
    
    // Scrolling the view down, revealing the navbar and tabbar
    if (delta < 0) {
        
        if (frameNav.origin.y - navDelta > kStatusBarHeight) {
            navDelta = frameNav.origin.y - kStatusBarHeight;
        }
        insetTop -= navDelta;
        
        frameNav.origin.y -= navDelta;
        self.navigationController.navigationBar.frame = frameNav;
        
        CGFloat maxTabBarX = kScreenHeight - CGRectGetHeight(frameTabBar);
        if (frameTabBar.origin.y + tabBarDelta < maxTabBarX) {
            tabBarDelta = maxTabBarX - frameTabBar.origin.y;
        }
        
        if (frameTabBar.origin.y + tabBarDelta1 < kScreenHeight - (CGRectGetHeight(frameTabBar) - kTabBarCenterButtondelta)) {
            tabBarDelta1 = MIN(0, kScreenHeight - (CGRectGetHeight(frameTabBar) - kTabBarCenterButtondelta) - frameTabBar.origin.y);
        }
        insetBottom -= tabBarDelta;
        
        frameTabBar.origin.y += tabBarDelta;
        self.tabBarController.tabBar.frame = frameTabBar;
        NSLog(@"delta < 0---navFrameY:%f",frameNav.origin.y);
        NSLog(@"delta < 0---tabBarDelta:%f",tabBarDelta);
        NSLog(@"delta < 0---tabBarDelta1:%f",tabBarDelta1);
        [self updateTableViewInsetTop:insetTop andInsetBottom:insetBottom];
        
    }
}

- (void)updateTableViewInsetTop:(CGFloat)insetTop andInsetBottom:(CGFloat)insetBottom {
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.top = insetTop;
    inset.bottom = insetBottom;
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
    NSLog(@"contentInset top:%f---bottom:%f",inset.top,inset.bottom);
}

- (void)checkForPartialScroll {
    CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
    __block CGRect frame = self.navigationController.navigationBar.frame;
    
    if (ABS(pos) < frame.size.height) {
        // Get back down
        if (ABS(pos) >= frame.size.height / 2) {
            [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

// Prevents the navbar and tabbar from moving during the 'rubberband' scroll
- (BOOL)checkRubberbanding:(CGFloat)delta {
    
    if (delta < 0) {
        NSLog(@"contentOffsetY:%f---height:%f---total:%f---contentSizeHeight:%f",self.tableView.contentOffset.y,self.tableView.frame.size.height,self.tableView.contentOffset.y + self.tableView.frame.size.height,self.tableView.contentSize.height);
        
        if (self.tableView.contentOffset.y + self.tableView.frame.size.height >= self.tableView.contentSize.height) {
            if (self.tableView.frame.size.height < self.tableView.contentSize.height) { // Only if the content is big enough
                return NO;
            }
        }
        
    } else {
        if (self.tableView.contentOffset.y <= -(kNavbarHeight + kStatusBarHeight)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat delta = contentOffsetY - self.lastContentOffsetY;
    NSLog(@"lastContentOffsetY:%f-----contentOffsetY:%f",self.lastContentOffsetY,contentOffsetY);
    self.lastContentOffsetY = contentOffsetY;
    NSLog(@"delta:%f",delta);
    if ([self checkRubberbanding:delta]) {
        [self scrollWithDelta:delta];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSLog(@"scrollViewDidEndDecelerating");
    self.lastContentOffsetY = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffsetY = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate; {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"scrollViewDidEndDragging");
//    [self checkForPartialScroll];
    //TODO: Get back down or up
}

@end
