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

@protocol EAIntroDelegate<NSObject>
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
@property (nonatomic, assign, readwrite) BOOL swipeToExit;
@property (nonatomic, assign, readwrite) BOOL tapToNext;
@property (nonatomic, assign, readwrite) BOOL hideOffscreenPages;
@property (nonatomic, assign, readwrite) BOOL easeOutCrossDisolves;
@property (nonatomic, assign, readwrite) BOOL showSkipButtonOnlyOnLastPage;
@property (nonatomic, assign, readwrite) BOOL useMotionEffects;
@property (nonatomic, assign, readwrite) CGFloat motionEffectsRelativeValue;
@property (nonatomic, assign, readwrite) UIViewContentMode bgViewContentMode;

// Page Control
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;
@property (nonatomic, assign, readwrite) CGFloat pageControlY;
@property (nonatomic, assign, readwrite) NSUInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSUInteger visiblePageIndex;

// Title View
@property (nonatomic, strong, readwrite) UIView *titleView;
@property (nonatomic, assign, readwrite) CGFloat titleViewY;

// Background image
@property (nonatomic, strong, readwrite) UIImage *bgImage;

@property (nonatomic, strong, readwrite) UIButton *skipButton;

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex animated:(BOOL)animated;

@end
