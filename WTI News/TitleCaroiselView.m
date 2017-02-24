//
//  TitleScrollView.m
//  WTI News
//
//  Created by 吴韬 on 17/2/15.
//  Copyright © 2017年 吴韬. All rights reserved.
//

#import "TitleCaroiselView.h"


@interface TitleCaroiselView()

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) NSMutableArray *subBtnArray;

@end

@implementation TitleCaroiselView


- (instancetype)init
{
    self = [super init];
    if (self) {
        _duringAnimation = NO;
    }
    return self;
}

- (void)configSubTitlesWith: (NSArray *)titleArray
{
    /* 依据传入标题数组添加button */
    NSInteger count = [titleArray count];
    CGRect viewFrame = CGRectMake(0, 0, 0, kTitleCarouselHeight);
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        [btn setTitle: titleArray[i] forState: UIControlStateNormal];
        [btn setTitleColor: kSubTitleNormalColor forState: UIControlStateNormal];
        [btn setTitleColor: kSubTitleSelectedColor forState: UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize: 15.0f];
        CGFloat width = [btn.titleLabel sizeThatFits: CGSizeMake(CGFLOAT_MAX, 40)].width + kTltleButtonExtend * 2;
        viewFrame.size.width += width;
        [btn addTarget: self action: @selector(titleBtnClicked:) forControlEvents: UIControlEventTouchUpInside];

        if (i == 0) {
            btn.frame = CGRectMake(0, 0, width, kTitleCarouselHeight);
            btn.selected = YES;
            self.sliderView.x = btn.x;
            self.sliderView.width = width;
            self.currentBtn = btn;
            _currentIndex = 0;
        } else {
            UIButton *lastBtn = [self.subBtnArray objectAtIndex: i - 1];
            btn.frame = CGRectMake(lastBtn.frame.origin.x + lastBtn.frame.size.width, 0, width, kTitleCarouselHeight);
        }
        btn.backgroundColor = [UIColor clearColor];
        [self.subBtnArray addObject: btn];
        
        [self addSubview: btn];
    }
    
    _titleCount = self.subBtnArray.count;
    self.frame = viewFrame;
}


#pragma mark - Tap Event

- (void)titleBtnClicked: (UIButton *)btn
{
    if (btn == self.currentBtn) {
        return;
    }
    
    btn.selected = YES;
    if (self.currentBtn) {
        self.currentBtn.selected = NO;
    }
    self.currentBtn = btn;
    _currentIndex = [self.subBtnArray indexOfObject: btn];
    
    if ([self.delegate respondsToSelector: @selector(titleCarouselViewClicked:titleButton:atIndex:)]) {
        [self.delegate titleCarouselViewClicked: self titleButton: btn atIndex: [self.subBtnArray indexOfObject: btn]];
    }
    
    [self sliderViewTranslationTo: btn];
}

- (void)sliderViewTranslationTo: (UIButton *)btn
{
    [UIView animateWithDuration: 0.5 animations:^{
        _duringAnimation = YES;
        self.sliderView.x = btn.x;
        self.sliderView.width = btn.width;
    } completion:^(BOOL finished) {
        _duringAnimation = NO;
    }];
}

- (void)stopAnimation
{
    _duringAnimation = NO;
    [self.sliderView.layer removeAllAnimations];
}


#pragma mark - Scroll Event

- (void)sliderViewToScroll: (CGFloat)offset;
{

    NSInteger index = (NSInteger)offset / SCREEN_WIDTH;
    CGRect baseFrame;
    CGRect aimFrame;
    
    if (offset <= 0) {
        UIButton *firstBtn = [self.subBtnArray objectAtIndex: 0];
        
        baseFrame = firstBtn.frame;
        aimFrame = baseFrame;
        aimFrame.origin.x -= baseFrame.size.width;
        
    } else if (offset >= (self.subBtnArray.count - 1) * SCREEN_WIDTH) {
        UIButton *lastBtn = [self.subBtnArray lastObject];
        
        baseFrame = lastBtn.frame;
        aimFrame = baseFrame;
        aimFrame.origin.x += baseFrame.size.width;
        
    } else {
        UIButton *leftBtn = [self.subBtnArray objectAtIndex: index];
        UIButton *rightBtn = [self.subBtnArray objectAtIndex: index + 1];
        
        baseFrame = leftBtn.frame;
        aimFrame = rightBtn.frame;
    }
    
    CGRect sliderFrame = self.sliderView.frame;
    
    CGFloat relativeOffset = offset < 0 ? fabs(offset) : offset - index * SCREEN_WIDTH;
    
    sliderFrame.origin.x = (aimFrame.origin.x - baseFrame.origin.x) * relativeOffset / SCREEN_WIDTH + baseFrame.origin.x;
    sliderFrame.size.width = (aimFrame.size.width - baseFrame.size.width) * relativeOffset /SCREEN_WIDTH + baseFrame.size.width;
    
    self.sliderView.frame = sliderFrame;
}

- (void)changeTitleButtonWith: (CGFloat)offset
{
    NSInteger index = (NSInteger)offset / SCREEN_WIDTH;
    
    if (index < 0 || index > self.subBtnArray.count) {
        return;
    }

    if (self.currentBtn) {
        self.currentBtn.selected = NO;
    }
    
    self.currentBtn = [self.subBtnArray objectAtIndex: index];
    self.currentBtn.selected = YES;
    _currentIndex = index;

    if ([self.delegate respondsToSelector: @selector(titleCarouselViewScrolled:titleButton:atIndex:)]) {
        [self.delegate titleCarouselViewScrolled: self titleButton: self.currentBtn atIndex: index];
    }
}


#pragma mark - Lazy Load

- (NSMutableArray *)subBtnArray
{
    if (!_subBtnArray) {
        _subBtnArray = [[NSMutableArray alloc] init];
    }
    return _subBtnArray;
}

- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame: CGRectMake(0, kTitleCarouselHeight - 4, 0, 4)];
        _sliderView.backgroundColor = [UIColor redColor];
        [self addSubview: _sliderView];
    }
    return _sliderView;
}


@end
