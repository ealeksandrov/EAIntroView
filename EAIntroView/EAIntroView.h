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
@property (nonatomic, assign) BOOL swipeToExit;
@property (nonatomic, assign) BOOL tapToNext;
@property (nonatomic, assign) BOOL hideOffscreenPages;
@property (nonatomic, assign) BOOL easeOutCrossDisolves;
@property (nonatomic, assign) BOOL showSkipButtonOnlyOnLastPage;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign) CGFloat motionEffectsRelativeValue;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) UIViewContentMode bgViewContentMode;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;
@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger visiblePageIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex;
- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex animated:(BOOL)animated;

@end
