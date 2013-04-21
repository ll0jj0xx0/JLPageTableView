//
//  JLPageTableView.h
//  quicksign2
//
//  Created by 嘉星 李 on 3/28/12.
//  Copyright (c) 2012 Lawrence Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol JLPageTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)pulledToRefresh;

@end

@protocol JLPageTableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

@interface JLPageTableView : UIView<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UITableView * _firstTableView;
    UITableView *_secondTableView;
    UITableView *_thirdTableView;
    
    UILabel *_pageNumberLabel;
    UIPageControl *_pageControl;
    UIView *_bottomView;
    
    NSObject<JLPageTableViewDelegate> *delegate;
    NSObject<JLPageTableViewDataSource> *dataSource;
    
    int pageIndex;
    int maxPage;
    BOOL scrollMode;
    BOOL pullToRefresh;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *firstTableView;
@property (nonatomic, retain) UITableView *secondTableView;
@property (nonatomic, retain) UITableView *thirdTableView;

@property (nonatomic, retain) UILabel *pageNumberLabel;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIView *bottomView;

@property (nonatomic, retain) NSObject<JLPageTableViewDelegate> *delegate;
@property (nonatomic, retain) NSObject<JLPageTableViewDataSource> *dataSource;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int maxPage;
@property (nonatomic, assign) BOOL scrollMode;
@property (nonatomic, assign) BOOL pullToRefresh;

- (void)reloadDataLazy;
- (void)reloadData;
- (void)refreshTable;
- (void)scrollTableViewWithPageIndex:(int)index;
- (void)addPullToRefreshHeader;

@end
