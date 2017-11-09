//
//  EAIntroView.h
//
//  Copyright (c) 2013-2017 Evgeny Aleksandrov. License: MIT.

#import <UIKit/UIKit.h>
#import <EARestrictedScrollView/EARestrictedScrollView.h>
#import "EAIntroPage.h"

#define EA_EMPTY_PROPERTY 9999.f

#define SKIP_BTN_DEFAULT_WIDTH 100.f
#define SKIP_BTN_DEFAULT_HEIGHT 40.f
#define PAGE_CTRL_DEFAULT_HEIGHT 36.f


enum EAIntroViewTags {
    kTitleLabelTag = 1,
    kDescLabelTag,
    kTitleImageViewTag
};

typedef NS_ENUM(NSUInteger, EAViewAlignment) {
    EAViewAlignmentLeft,
    EAViewAlignmentCenter,
    EAViewAlignmentRight,
};

@class EAIntroView;

@protocol EAIntroDelegate<NSObject>
@optional
- (void)introWillFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped;
- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped;
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex;
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex;
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex;

// Called for every incremental scroll event.
// Parameter offset is some fraction of the currentPageIndex, between currentPageIndex-1 and currentPageIndex+1
// For example, scrolling left and right from page 2 will values in the range [1..3], exclusive
- (void)intro:(EAIntroView *)introView didScrollWithOffset:(CGFloat)offset;
@end

@interface EAIntroView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<EAIntroDelegate> delegate;

@property (nonatomic, assign) BOOL swipeToExit;
@property (nonatomic, assign) BOOL tapToNext;
@property (nonatomic, assign) BOOL hideOffscreenPages;
@property (nonatomic, assign) BOOL easeOutCrossDisolves;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign) CGFloat motionEffectsRelativeValue;

// Title View (Y position - from top of the screen)
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;

// Background image
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) UIViewContentMode bgViewContentMode;

// Page Control (Y position - from bottom of the screen)
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;

@property (nonatomic, assign, readonly) NSUInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSUInteger visiblePageIndex;

// Skip button (Y position - from bottom of the screen)
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, assign) CGFloat skipButtonY;
@property (nonatomic, assign) CGFloat skipButtonSideMargin;
@property (nonatomic, assign) EAViewAlignment skipButtonAlignment;
@property (nonatomic, assign) BOOL showSkipButtonOnlyOnLastPage;

@property (nonatomic, assign) NSInteger limitPageIndex;

@property (nonatomic, strong) EARestrictedScrollView *scrollView;
@property (nonatomic, assign) BOOL scrollingEnabled;
@property (nonatomic, strong) NSArray<EAIntroPage *> *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray<EAIntroPage *> *)pagesArray;

- (void)showFullscreen;
- (void)showFullscreenWithAnimateDuration:(CGFloat)duration;
- (void)showFullscreenWithAnimateDuration:(CGFloat)duration andInitialPageIndex:(NSUInteger)initialPageIndex;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration withInitialPageIndex:(NSUInteger)initialPageIndex;

- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)scrollToPageForIndex:(NSUInteger)newPageIndex animated:(BOOL)animated;

@end
