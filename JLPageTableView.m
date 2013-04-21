//
//  JLPageTableView.m
//  quicksign2
//
//  Created by 嘉星 李 on 3/28/12.
//  Copyright (c) 2012 Lawrence Tech. All rights reserved.
//

#import "JLPageTableView.h"
#import "JLAppDelegate.h"

@implementation JLPageTableView

@synthesize scrollView = _scrollView;
@synthesize firstTableView = _firstTableView;
@synthesize secondTableView = _secondTableView;
@synthesize thirdTableView = _thirdTableView;

@synthesize pageNumberLabel = _pageNumberLabel;
@synthesize pageControl = _pageControl;
@synthesize bottomView = _bottomView;

@synthesize delegate;
@synthesize dataSource;

@synthesize pageIndex;
@synthesize maxPage;
@synthesize scrollMode;
@synthesize pullToRefresh;

#define OFFSET 60

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [aScrollView setDelegate:self];
        [self setScrollView:aScrollView];
        [aScrollView release];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
        [self.scrollView setBounces:NO];
        [self addSubview:self.scrollView];
        
        UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [tableView1 setDelegate:self];
        [tableView1 setDataSource:self];
        [tableView1 setScrollEnabled:NO];
        //[tableView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]]];
        [tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //[tableView1 setSeparatorColor:[UIColor blackColor]];
        [self setFirstTableView:tableView1];
        [tableView1 release];
        
        UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        [tableView2 setDelegate:self];
        [tableView2 setDataSource:self];
        [tableView2 setScrollEnabled:NO];
        //[tableView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]]];
        [tableView2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //[tableView2 setSeparatorColor:[UIColor blackColor]];
        [self setSecondTableView:tableView2];
        [tableView2 release];
        
        UITableView *tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
        [tableView3 setDelegate:self];
        [tableView3 setDataSource:self];
        [tableView3 setScrollEnabled:NO];
        //[tableView3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]]];
        [tableView3 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //[tableView3 setSeparatorColor:[UIColor blackColor]];
        [self setThirdTableView:tableView3];
        [tableView3 release];
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        [self setPageNumberLabel:aLabel];
        [aLabel release];
        [self.pageNumberLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
        [self.pageNumberLabel setFont:[UIFont systemFontOfSize:14]];
        [self.pageNumberLabel setTextAlignment:UITextAlignmentCenter];
        
        UIPageControl *aPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        [aPageControl setCenter:CGPointMake(frame.size.width / 2, frame.size.height - 10)];
        [aPageControl.layer setCornerRadius:7.0f];
        [self setPageControl:aPageControl];
        [aPageControl release];
        
        UIView *aBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        [aBottomView setBackgroundColor:[UIColor clearColor]];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = aBottomView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor], (id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [aBottomView.layer insertSublayer:gradient atIndex:0];
        [self setBottomView:aBottomView];
        [aBottomView release];
        
        [self.scrollView addSubview:self.firstTableView];
        [self.scrollView addSubview:self.secondTableView];
        [self.scrollView addSubview:self.thirdTableView];
        //[self addSubview:self.pageNumberLabel];
        [self addSubview:self.bottomView];
        [self addSubview:self.pageControl];
        
        [self setPullToRefresh:NO];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_scrollView release];
    [_firstTableView release];
    [_secondTableView release];
    [_thirdTableView release];
    [_pageNumberLabel release];
    [_pageControl release];
    [_bottomView release];
    [delegate release];
    [dataSource release];
    [super dealloc];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.firstTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.secondTableView setFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    [self.thirdTableView setFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
    [self.pageNumberLabel setFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
    [self.pageControl setFrame:CGRectMake(0, frame.size.height - 20, self.pageControl.frame.size.width, self.pageControl.frame.size.height)];
    [self.pageControl setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height - 10)];
    
    [self.bottomView setFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
    [[[self.bottomView.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor], (id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.bottomView.layer insertSublayer:gradient atIndex:0];
    
    [self refreshTable];
    [self scrollTableViewWithPageIndex:0];
}

/*
- (void)layoutSubviews {
    CGRect frame = self.frame;
    [self.scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.firstTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.secondTableView setFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    [self.thirdTableView setFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
    [self.pageNumberLabel setFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
    
    //[self refreshTable];
    [self scrollTableViewWithPageIndex:0];
}*/

- (CGFloat)tableViewHeight
{
    [self.firstTableView layoutIfNeeded];
    CGFloat height = [self.firstTableView contentSize].height - [self.firstTableView tableFooterView].frame.size.height;
    if (DEBUGMODE) {
        NSLog(@"table height:%d", (int)height);
    }   
    return height;
}

- (void)setMaxPageByContentHeight:(float)height {
    int pageNumber = 0;
    int adjustHeight = 0;
    if (self.scrollMode) {
        pageNumber = 1;
        adjustHeight = 40;
        [self.firstTableView setScrollEnabled:YES];
    }
    else {
        [self.firstTableView setScrollEnabled:NO];
        
        if (height <= self.frame.size.height - OFFSET) {
            pageNumber = 1;
            adjustHeight = self.frame.size.height - height;
        }
        else {
            pageNumber = ceil(height / (self.frame.size.height - OFFSET));
            adjustHeight = pageNumber * (self.frame.size.height - OFFSET) + OFFSET - height;
        }
        if (DEBUGMODE) {
            NSLog(@"adjust height:%d", (int)adjustHeight);
        }
    }
    
    [self setMaxPage:pageNumber];
    
    UIView *footer1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, adjustHeight)];
    //[footer1 setBackgroundColor:[UIColor redColor]];
    self.firstTableView.tableFooterView = footer1;
    [footer1 release];
    
    UIView *footer2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, adjustHeight)];
    //[footer2 setBackgroundColor:[UIColor redColor]];
    self.secondTableView.tableFooterView = footer2;
    [footer2 release];
    
    UIView *footer3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, adjustHeight)];
    //[footer3 setBackgroundColor:[UIColor redColor]];
    self.thirdTableView.tableFooterView = footer3;
    [footer3 release];
    
    if (maxPage < 3) {
        [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * maxPage, self.frame.size.height)];
    }
    else {
        [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
    }
    
    [self.pageControl setNumberOfPages:maxPage];
    CGSize pagecontrolsize = [self.pageControl sizeForNumberOfPages:maxPage];
    [self.pageControl setFrame:CGRectMake(0, self.frame.size.height - 20, pagecontrolsize.width + 12, 14)];
    [self.pageControl setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.pageControl setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height - 10)];
    if (maxPage == 1) {
        [self.pageControl setHidden:YES];
    }
    else {
        [self.pageControl setHidden:NO];
    }
}

- (void)scrollTableViewWithPageIndex:(int)index {
    [self setPageIndex:index];
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int contentHeight = height - OFFSET;
    if (self.maxPage == 1 && index == 0) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index), width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index), width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index), width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
    }
    if (self.maxPage == 2 && index == 0) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * 0, width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * 1, width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * 1, width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
    }
    if (self.maxPage == 2 && index == 1) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * 0, width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * 1, width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * 1, width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    }
    if (self.maxPage >=3 && index > 0 && index < self.maxPage - 1) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index - 1), width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index), width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * (index + 1), width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    }
    if (self.maxPage >=3 && index == 0) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * 0, width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * 1, width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * 2, width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
    }
    if (self.maxPage >=3 && index == self.maxPage - 1) {
        [self.firstTableView scrollRectToVisible:CGRectMake(0, contentHeight * (self.maxPage - 3), width, height) animated:NO];
        [self.secondTableView scrollRectToVisible:CGRectMake(0, contentHeight * (self.maxPage - 2), width, height) animated:NO];
        [self.thirdTableView scrollRectToVisible:CGRectMake(0, contentHeight * (self.maxPage - 1), width, height) animated:NO];
        [self.scrollView scrollRectToVisible:CGRectMake(2 * width, 0, width, height) animated:NO];
    }
    
    [self.pageNumberLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Page %d of %d", nil), index + 1, self.maxPage]];
    [self.pageControl setCurrentPage:index];
    //NSLog(@"1:%f, 2:%f, 3:%f", self.firstTableView.contentOffset.y, self.secondTableView.contentOffset.y, self.thirdTableView.contentOffset.y);
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollMode) {
        return;
    }
    int width = self.frame.size.width;
    // All data for the documents are stored in an array (documentTitles).
    // We keep track of the index that we are scrolling to so that we
    // know what data to load for each page.
    if (scrollView.contentOffset.x > width) {
        if (pageIndex == 0) {
            pageIndex += 2; 
        }
        else if (pageIndex < maxPage - 1 && pageIndex > 0){
            pageIndex++;
        }
    }
    else if (scrollView.contentOffset.x < width) {
        if (maxPage >= 3) {
            if (pageIndex == maxPage - 1) {
                pageIndex -= 2;
            }
            else if (pageIndex < maxPage - 1 && pageIndex > 0){
                pageIndex --;
            }
        }
        else if (maxPage == 2) {
            if (pageIndex == 1) {
                pageIndex = 0;
            }
        }
    }
    else if (scrollView.contentOffset.x == width) {
        if (maxPage >= 3) {
            if (self.pageIndex == 0) {
                self.pageIndex++;
            }
            else if (pageIndex == maxPage - 1) {
                self.pageIndex--;
            }
        }
        else if (maxPage == 2) {
            if (pageIndex == 0) {
                pageIndex = 1;
            }
        }
    }
    [self scrollTableViewWithPageIndex:self.pageIndex];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - Customized Methods

- (void)reloadDataLazy {
    if (maxPage == 1) {
        //do nothing
    }
    else if (maxPage == 2) {
        if (pageIndex == 0) {
            [self.secondTableView reloadData];
        }
        else if (pageIndex == 1) {
            [self.firstTableView reloadData];
        }
    }
    else if (maxPage >= 3) {
        if (pageIndex == 0) {
            [self.secondTableView reloadData];
            [self.thirdTableView reloadData];
        }
        else if (pageIndex == maxPage - 1) {
            [self.firstTableView reloadData];
            [self.secondTableView reloadData];
        }
        else {
            [self.firstTableView reloadData];
            [self.thirdTableView reloadData];
        }
    }
}

- (void)reloadData {
    [self.firstTableView reloadData];
    [self.secondTableView reloadData];
    [self.thirdTableView reloadData];
}

- (void)refreshTable {
    [self.firstTableView reloadData];
    [self.secondTableView reloadData];
    [self.thirdTableView reloadData];
    [self setMaxPageByContentHeight:[self tableViewHeight]];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)addPullToRefreshHeader {
    UILabel *refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, self.firstTableView.frame.size.width, 60)];
    [refreshLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textColor = [UIColor darkGrayColor];
    refreshLabel.shadowColor = [UIColor whiteColor];
    refreshLabel.shadowOffset = CGSizeMake(0, 1);
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    [refreshLabel setTag:111];
    
    [refreshLabel setText:NSLocalizedString(@"Pull down to refresh...", nil)];
    [self.firstTableView addSubview:refreshLabel];
    [refreshLabel release];
    
    [self setPullToRefresh:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pullToRefresh && scrollView == self.firstTableView && scrollView.contentOffset.y < -60) {
        UILabel *refreshLabel = (UILabel *)[self.firstTableView viewWithTag:111];
        [refreshLabel setText:NSLocalizedString(@"Release to refresh...", nil)];
    }
    else if (self.pullToRefresh && scrollView == self.firstTableView && scrollView.contentOffset.y < 0){
        UILabel *refreshLabel = (UILabel *)[self.firstTableView viewWithTag:111];
        [refreshLabel setText:NSLocalizedString(@"Pull down to refresh...", nil)];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.pullToRefresh && scrollView == self.firstTableView && scrollView.contentOffset.y <= -60) {
        // Released above the header
        [delegate pulledToRefresh];
    }
}


@end
