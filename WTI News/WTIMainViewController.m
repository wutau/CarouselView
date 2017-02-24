//
//  WTIMainViewController.m
//  WTI News
//
//  Created by 吴韬 on 17/2/15.
//  Copyright © 2017年 吴韬. All rights reserved.
//

#import "WTIMainViewController.h"
#import "TitleCaroiselView.h"
#import "UIBarButtonItem+Extension.h"

@interface WTIMainViewController () <UIScrollViewDelegate, TitleCarouselViewDelegate>
{
    /* 
     * 点击事件时，设置UIScrollView.ContentOffset会调用scrollViewDidScroll方法
     * 由于此时是动画控制sliderView，不需要通过该方法改变其frame
     * 所以当scrollViewWillBeginDragging时，需要检查是否为点击事件
     */
    BOOL _titleClicked;
}

@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) TitleCaroiselView *titleCaroiselView;

@end

@implementation WTIMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicSetting];
    [self configTitleScrollView];
    [self configPageScrollView];
    [self createSubViewController];
}

- (void)basicSetting
{
    self.navigationItem.title = @"WTI News";
    UIBarButtonItem *menuItem = [UIBarButtonItem barButtonItemTaget: nil action: nil imageNormal: @"nav_menu" imageHighlighted: @"nav_menu_highLighted"];
    self.navigationItem.rightBarButtonItems = @[menuItem];
    self.navigationController.navigationBar.translucent = NO;

    _titleClicked = NO;
}

- (void)configPageScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, kTitleCarouselHeight + 1, SCREEN_WIDTH, SCREEN_HEIGHT - kTitleCarouselHeight - 1)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES; //拖拽结束继续调用scrollViewDidScroll方法，将SliderView归位
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleCaroiselView.titleCount, 0);
    scrollView.delegate = self;
    
    self.pageScrollView = scrollView;
    [self.view addSubview: scrollView];
}

- (void)configTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, kTitleCarouselHeight)];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.contentSize = CGSizeMake(self.titleCaroiselView.width, 0);
    self.titleScrollView = titleScrollView;
    [self.titleScrollView addSubview: self.titleCaroiselView];
    [self.view addSubview: self.titleScrollView];
}

- (void)createSubViewController
{
    NSInteger count = self.titleCaroiselView.titleCount;
    
    for (NSInteger i = 0; i < count; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        vc.view.backgroundColor = UI_RAMDOM_COLOR;
        [self.pageScrollView addSubview: vc.view];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
    /* 滑动结束更新titleButton，如果在减速过程中再次滑动或点击，则不调用此方法 */
    if (self.pageScrollView != scrollView) {
        return;
    }
    [self.titleCaroiselView changeTitleButtonWith: self.pageScrollView.contentOffset.x];
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    if (self.pageScrollView == scrollView) {
        if (_titleClicked) {
            return;
        }
        [self.titleCaroiselView sliderViewToScroll: self.pageScrollView.contentOffset.x];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.pageScrollView == scrollView) {
        _titleClicked = NO;
        //如果用户在点击动画过程中拖动屏幕，则移除动画，交由scoll事件控制
        if (self.titleCaroiselView.duringAnimation) {
            [self.titleCaroiselView stopAnimation];
            [self.pageScrollView.layer removeAllAnimations];
        }
    }
}

- (void)refreshScrollViewContentOffset: (CGFloat)offset index: (NSInteger) index during: (NSTimeInterval)time pageChange: (BOOL)pageChange
{
    [UIView animateWithDuration: time animations:^{
        if (offset <= SCREEN_WIDTH * 0.5) {
            self.titleScrollView.contentOffset = CGPointMake(0, 0);
        } else if (offset >= self.titleCaroiselView.width - SCREEN_WIDTH * 0.5) {
            self.titleScrollView.contentOffset = CGPointMake(self.titleScrollView.contentSize.width - SCREEN_WIDTH, 0);
        } else {
            self.titleScrollView.contentOffset = CGPointMake(offset - SCREEN_WIDTH * 0.5, 0);
        }
    }];
    
    if (pageChange) {
//        [UIView animateWithDuration: time delay: 0 options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
//            
//                self.pageScrollView.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
//            
//        } completion:^(BOOL finished) {
//            
//        }];
        [self.pageScrollView setContentOffset: CGPointMake(index * SCREEN_WIDTH, 0) animated: YES];
    }
}


#pragma mark - TitleCarouselViewDelegate

- (void)titleCarouselViewClicked:(TitleCaroiselView *)titleCaroiselView titleButton:(UIButton *)button atIndex:(NSInteger)index
{
    _titleClicked = YES;
    CGFloat offset = button.x + button.width * 0.5;
    [self refreshScrollViewContentOffset: offset index: index during: 0.5 pageChange: YES];
}

- (void)titleCarouselViewScrolled: (TitleCaroiselView *)titleCaroiselView titleButton: (UIButton *)button atIndex: (NSInteger)index
{
    CGFloat offset = button.x + button.width * 0.5;
    [self refreshScrollViewContentOffset: offset index: index during: 0.5 pageChange: NO];
}


#pragma mark - Lazy Load

- (TitleCaroiselView *)titleCaroiselView
{
    if (!_titleCaroiselView) {
        _titleCaroiselView = [[TitleCaroiselView alloc] init];
        NSArray *titleArray = @[@"LIVE",@"Top Stories",@"My News",@"Most Read",@"Most Watched"];
        [_titleCaroiselView configSubTitlesWith: titleArray];
        _titleCaroiselView.delegate = self;
        _titleScrollView.backgroundColor = UICOLOR(150, 150, 150, 0.8);
    }
    return _titleCaroiselView;
}

@end
