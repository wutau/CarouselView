//
//  TitleScrollView.h
//  WTI News
//
//  Created by 吴韬 on 17/2/15.
//  Copyright © 2017年 吴韬. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleCaroiselView;

@protocol TitleCarouselViewDelegate <NSObject>

/* 点击titleButton通知 */
- (void)titleCarouselViewClicked: (TitleCaroiselView *)titleCaroiselView titleButton: (UIButton *)button atIndex: (NSInteger)index;

/* 滑动titleButton通知 */
- (void)titleCarouselViewScrolled: (TitleCaroiselView *)titleCaroiselView titleButton: (UIButton *)button atIndex: (NSInteger)index;

@end

@interface TitleCaroiselView : UIView

@property (weak, nonatomic) id <TitleCarouselViewDelegate> delegate;
/* 标题总数 */
@property (nonatomic, assign, readonly) NSInteger titleCount;
/* 当前选中Button */
@property (nonatomic, assign, readonly) NSInteger currentIndex;
/* 点击事件动画正在进行 */
@property (nonatomic, assign, readonly) BOOL duringAnimation;

/* 拖动时滑条动态变化, offset为主界面视图容器Scrollview总偏移量 */
- (void)sliderViewToScroll: (CGFloat)offset;

/* 拖动结束，更新currentButton */
- (void)changeTitleButtonWith: (CGFloat)offset;

/* 根据传入数组初始化视图 */
- (void)configSubTitlesWith: (NSArray *)titleArray;

/* 当正在进行点击动画时发生拖动事件，停止动画 */
- (void)stopAnimation;

@end
