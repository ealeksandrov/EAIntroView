//
//  EAIntroView.h
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import <UIKit/UIKit.h>
#import "EAIntroPage.h"

enum EAIntroViewTags {
    kTitleLabelTag = 1,
    kDescLabelTag,
    kTitleImageViewTag
};

@class EAIntroView;

@protocol EAIntroDelegate
@optional
- (void)introDidFinish:(EAIntroView *)introView;
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSInteger)pageIndex;
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex;
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex;
@end

@interface EAIntroView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<EAIntroDelegate> delegate;

// titleView Y position - from top of the screen
// pageControl Y position - from bottom of the screen
@property (nonatomic, assign) bool swipeToExit;
@property (nonatomic, assign) bool tapToNext;
@property (nonatomic, assign) bool hideOffscreenPages;
@property (nonatomic, assign) bool easeOutCrossDisolves;
@property (nonatomic, assign) bool showSkipButtonOnlyOnLastPage;
@property (nonatomic, assign) bool useMotionEffects;
@property (nonatomic, assign) CGFloat motionEffectsRelativeValue;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) UIViewContentMode bgViewContentMode;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;
@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger visiblePageIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex;
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated;

@end
