//
//  EAIntroView.m
//
//  Copyright (c) 2013-2017 Evgeny Aleksandrov. License: MIT.

#import "EAIntroView.h"
#import "EARestrictedScrollView.h"

@interface EAIntroView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *pageBgBack;
@property (nonatomic, strong) UIImageView *pageBgFront;

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *footerConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *titleViewConstraints;

@property (nonatomic, assign) BOOL skipped;

@end

@interface EAIntroPage()

@property (nonatomic, strong, readwrite) UIView *pageView;

@end


@implementation EAIntroView

@synthesize pageControl = _pageControl;
@synthesize skipButton = _skipButton;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithFrame:frame pages:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithFrame:self.frame pages:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andPages:(NSArray<EAIntroPage *> *)pagesArray {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithFrame:self.frame pages:pagesArray];
    }
    return self;
}

#pragma mark - Private

- (void)applyDefaultsToSelfDuringInitializationWithFrame:(CGRect)frame pages:(NSArray<EAIntroPage *> *)pagesArray {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.swipeToExit = YES;
    self.easeOutCrossDisolves = YES;
    self.hideOffscreenPages = YES;
    self.bgViewContentMode = UIViewContentModeScaleAspectFill;
    self.motionEffectsRelativeValue = 40.f;
    self.backgroundColor = [UIColor blackColor];
    _scrollingEnabled = YES;
    _titleViewY = 20.f;
    _pageControlY = 70.f;
    _skipButtonY = EA_EMPTY_PROPERTY;
    _skipButtonSideMargin = 10.f;
    _skipButtonAlignment = EAViewAlignmentRight;
	_skipped = NO;
    _limitPageIndex = -1;

    [self buildBackgroundImage];

    self.pages = [pagesArray copy];

    [self buildFooterView];
}

- (void)applyDefaultsToBackgroundImageView:(UIImageView *)backgroundImageView {
    backgroundImageView.backgroundColor = [UIColor clearColor];
    backgroundImageView.contentMode = self.bgViewContentMode;
    backgroundImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)makePanelVisibleAtIndex:(NSUInteger)panelIndex{
    [UIView animateWithDuration:0.3 animations:^{
        for (int idx = 0; idx < _pages.count; idx++) {
            if (idx == panelIndex) {
                [[self viewForPageIndex:idx] setAlpha:[self alphaForPageIndex:idx]];
            } else {
                if (!self.hideOffscreenPages) {
                    [[self viewForPageIndex:idx] setAlpha:0.f];
                }
            }
        }
    }];
}

- (EAIntroPage *)pageForIndex:(NSUInteger)idx {
    if (idx >= _pages.count) {
        return nil;
    }

    return (EAIntroPage *)_pages[idx];
}

- (CGFloat)alphaForPageIndex:(NSUInteger)idx {
    if (![self pageForIndex:idx]) {
        return 1.f;
    }

    return [self pageForIndex:idx].alpha;
}

- (BOOL)showTitleViewForPage:(NSUInteger)idx {
    if (![self pageForIndex:idx]) {
        return NO;
    }

    return [self pageForIndex:idx].showTitleView;
}

- (UIView *)viewForPageIndex:(NSUInteger)idx {
    return [self pageForIndex:idx].pageView;
}

- (UIImage *)bgImageForPage:(NSUInteger)idx {
    return [self pageForIndex:idx].bgImage;
}

- (UIColor *)bgColorForPage:(NSUInteger)idx {
    return [self pageForIndex:idx].bgColor;
}

- (void)showPanelAtPageControl {
    if (self.scrollView.tracking || self.scrollView.dragging) {
        return;
    }

    [self makePanelVisibleAtIndex:self.currentPageIndex];

    [self scrollToPageForIndex:self.pageControl.currentPage animated:YES];
}

- (void)checkIndexForScrollView:(EARestrictedScrollView *)scrollView {
    NSUInteger newPageIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2) / self.scrollView.bounds.size.width;
    [self notifyDelegateWithPreviousPage:self.currentPageIndex andCurrentPage:newPageIndex];
    _currentPageIndex = newPageIndex;

    if (self.currentPageIndex == _pages.count) {

        // If run here, it means you can't  call _pages[self.currentPageIndex],
        // to be safe, set to the biggest index
        _currentPageIndex = _pages.count - 1;

        if ([self.delegate respondsToSelector:@selector(introWillFinish:wasSkipped:)]) {
            [self.delegate introWillFinish:self wasSkipped:self.skipped];
        }

        [self finishIntroductionAndRemoveSelf];
    }
}

- (void)finishIntroductionAndRemoveSelf {
    // Prevent last page flicker on disappearing
    self.alpha = 0.f;

    // Calling removeFromSuperview from scrollViewDidEndDecelerating: method leads to crash on iOS versions < 7.0
    // removeFromSuperview should be called after a delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([(id)self.delegate respondsToSelector:@selector(introDidFinish:wasSkipped:)]) {
            [self.delegate introDidFinish:self wasSkipped:self.skipped];
        }

        [self removeFromSuperview];
    });
}

- (void)skipIntroduction {
	self.skipped = YES;
    [self hideWithFadeOutDuration:0.3];
}

- (void)notifyDelegateWithPreviousPage:(NSUInteger)previousPageIndex andCurrentPage:(NSUInteger)currentPageIndex {
    if (currentPageIndex!=_currentPageIndex && currentPageIndex < _pages.count) {
        EAIntroPage *previousPage = _pages[previousPageIndex];
        EAIntroPage *currentPage = _pages[currentPageIndex];
        if (previousPage.onPageDidDisappear) previousPage.onPageDidDisappear();
        if (currentPage.onPageDidAppear) currentPage.onPageDidAppear();

        if ([(id)self.delegate respondsToSelector:@selector(intro:pageAppeared:withIndex:)]) {
            [self.delegate intro:self pageAppeared:_pages[currentPageIndex] withIndex:currentPageIndex];
        }
    }
}

#pragma mark - Properties

- (EARestrictedScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[EARestrictedScrollView alloc] initWithFrame:self.bounds];
        _scrollView.accessibilityIdentifier = @"intro_scroll";
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _scrollView;
}

- (NSUInteger)visiblePageIndex {
    return (NSUInteger) ((self.scrollView.contentOffset.x + self.scrollView.bounds.size.width/2) / self.scrollView.bounds.size.width);
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self applyDefaultsToBackgroundImageView:_bgImageView];
    }
    return _bgImageView;
}

- (UIImageView *)pageBgBack {
    if (!_pageBgBack) {
        _pageBgBack = [[UIImageView alloc] initWithFrame:self.bounds];
        [self applyDefaultsToBackgroundImageView:_pageBgBack];
        _pageBgBack.alpha = 0.f;
    }
    return _pageBgBack;
}

- (UIImageView *)pageBgFront {
    if (!_pageBgFront) {
        _pageBgFront = [[UIImageView alloc] initWithFrame:self.bounds];
        [self applyDefaultsToBackgroundImageView:_pageBgFront];
        _pageBgFront.alpha = 0.f;
    }
    return _pageBgFront;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [self applyDefaultsToPageControl];
    }
    return _pageControl;
}

- (void)applyDefaultsToPageControl {
    _pageControl.defersCurrentPageDisplay = YES;
    _pageControl.numberOfPages = _pages.count;
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
        [self applyDefaultsToSkipButton];
    }
    return _skipButton;
}

- (void)applyDefaultsToSkipButton {
    _skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableArray *)footerConstraints {
    if (!_footerConstraints) {
        _footerConstraints = [NSMutableArray array];
    }
    return _footerConstraints;
}

- (NSMutableArray *)titleViewConstraints {
    if (!_titleViewConstraints) {
        _titleViewConstraints = [NSMutableArray array];
    }
    return _titleViewConstraints;
}

#pragma mark - UI building

- (void)buildBackgroundImage {
    [self addSubview:self.bgImageView];
    [self addSubview:self.pageBgBack];
    [self addSubview:self.pageBgFront];

    if (self.useMotionEffects) {
        [self addMotionEffectsOnBg];
    }
}

- (void)buildScrollView {
    CGFloat contentXIndex = 0;
    for (NSUInteger idx = 0; idx < _pages.count; idx++) {
        EAIntroPage *page = _pages[idx];
        page.pageView = [self viewForPage:page atXIndex:contentXIndex];
        contentXIndex += self.scrollView.bounds.size.width;
        [self.scrollView addSubview:page.pageView];
        if (page.onPageDidLoad) page.onPageDidLoad();
    }

    [self makePanelVisibleAtIndex:0];

    if (self.swipeToExit) {
        [self appendCloseViewAtXIndex:&contentXIndex];
    }

    [self insertSubview:self.scrollView aboveSubview:self.pageBgFront];
    self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.bounds.size.height);

    self.pageBgBack.alpha = 0;
    self.pageBgBack.image = [self bgImageForPage:1];
    self.pageBgBack.backgroundColor = [self bgColorForPage:1];
    self.pageBgFront.alpha = [self alphaForPageIndex:0];
    self.pageBgFront.image = [self bgImageForPage:0];
    self.pageBgFront.backgroundColor = [self bgColorForPage:0];
}

- (UIView *)viewForPage:(EAIntroPage *)page atXIndex:(CGFloat)xIndex {
    UIView *pageView = [self createViewForPage:page atXIndex:xIndex];

    if (page.customView) {
        [self configurePageView:pageView withCustomView:page.customView];
    } else {
        [self configurePageView:pageView forPage:page];
    }

    return pageView;
}

- (UIView *)createViewForPage:(EAIntroPage *)page atXIndex:(CGFloat)xIndex {
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(xIndex, 0.f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];

    pageView.accessibilityLabel = [NSString stringWithFormat:@"intro_page_%lu",(unsigned long)[self.pages indexOfObject:page]];

    if (page.alpha < 1.f || !page.bgImage) {
        self.backgroundColor = [UIColor clearColor];
    }
    return pageView;
}

- (void)configurePageView:(UIView *)pageView withCustomView:(UIView *)customView {
    [self addTapToNextActionToPageView:customView];
    [pageView addSubview:customView];

    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[customView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"customView": customView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[customView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"customView": customView}]];

    [pageView addConstraints:constraints];
}

- (void)configurePageView:(UIView *)pageView forPage:(EAIntroPage *)page {
    [self addTapToNextActionToPageView:pageView];
    [self applyAccessibilityLabelForPage:page toView:pageView];

    UIView *titleImageView;
    if (page.titleIconView) {
        titleImageView = page.titleIconView;
        titleImageView.tag = kTitleImageViewTag;
        titleImageView.translatesAutoresizingMaskIntoConstraints = NO;

        CGFloat aspectRatioMult = titleImageView.frame.size.width / titleImageView.frame.size.height;

        [pageView addSubview:titleImageView];
        [pageView addConstraint:[NSLayoutConstraint constraintWithItem:titleImageView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:titleImageView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:aspectRatioMult
                                                              constant:0.f]];
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topSpace@250)-[titleImageView]"
                                                                         options:NSLayoutFormatAlignAllTop
                                                                         metrics:@{@"topSpace": @(page.titleIconPositionY)}
                                                                           views:@{@"titleImageView": titleImageView}]];
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[titleImageView]-(>=0)-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"titleImageView": titleImageView}]];
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[titleImageView]"
                                                                         options:NSLayoutFormatAlignAllCenterX
                                                                         metrics:nil
                                                                           views:@{@"superview": pageView, @"titleImageView": titleImageView}]];
    }

    UILabel *titleLabel;
    if (page.title.length) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = page.title;
        titleLabel.font = page.titleFont;
        titleLabel.textColor = page.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = page.titleAlignment;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = kTitleLabelTag;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.isAccessibilityElement = NO;

        [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        [pageView addSubview:titleLabel];
        NSLayoutConstraint *weakConstraint = [NSLayoutConstraint constraintWithItem:pageView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:titleLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:page.titlePositionY];
        weakConstraint.priority = UILayoutPriorityDefaultLow;
        [pageView addConstraint:weakConstraint];
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|"
                                                                         options:NSLayoutFormatAlignAllTop
                                                                         metrics:nil
                                                                           views:@{@"titleLabel": titleLabel}]];
    }

    UITextView *descLabel;
    if (page.desc.length) {
        descLabel = [[UITextView alloc] init];
        descLabel.text = page.desc;
        descLabel.scrollEnabled = NO;
        descLabel.font = page.descFont;
        descLabel.textColor = page.descColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = page.descAlignment;
        descLabel.userInteractionEnabled = NO;
        descLabel.tag = kDescLabelTag;
        descLabel.translatesAutoresizingMaskIntoConstraints = NO;
        descLabel.isAccessibilityElement = NO;

        [descLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        [pageView addSubview:descLabel];
        NSLayoutConstraint *weakConstraint = [NSLayoutConstraint constraintWithItem:pageView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:descLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:page.descPositionY];
        weakConstraint.priority = UILayoutPriorityDefaultLow;
        [pageView addConstraint:weakConstraint];
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(descMargin)-[descLabel]-(descMargin)-|"
                                                                         options:NSLayoutFormatAlignAllTop
                                                                         metrics:@{@"descMargin": @(page.descSideMargin)}
                                                                           views:@{@"descLabel": descLabel}]];
    }

    // Constraints for handling landscape orientation
    if (titleImageView && titleLabel && descLabel) {
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[titleImageView]-(>=0)-[titleLabel]-(>=0)-[descLabel]-(>=0)-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"titleImageView": titleImageView, @"titleLabel": titleLabel, @"descLabel": descLabel}]];
    } else if (!titleImageView && titleLabel && descLabel) {
        [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[titleLabel]-(>=0)-[descLabel]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"titleLabel": titleLabel, @"descLabel": descLabel}]];
    }

    if (page.subviews) {
        for (UIView *subV in page.subviews) {
            [pageView addSubview:subV];
        }
    }

    pageView.alpha = page.alpha;
}

- (void)addTapToNextActionToPageView:(UIView *)pageView {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];

    [pageView addGestureRecognizer:tapRecognizer];
}

- (void)applyAccessibilityLabelForPage:(EAIntroPage *)page toView:(UIView *)view {
    NSString *accessibilityLabel = [self accessibilityLabelForPage:page];
    if (accessibilityLabel.length > 0) {
        view.isAccessibilityElement = YES;
        view.accessibilityLabel = accessibilityLabel;
        view.accessibilityTraits = UIAccessibilityTraitButton;
    }
}

- (NSString *)accessibilityLabelForPage:(EAIntroPage *)page {
    NSString *accessibilityLabel = nil;
    if (page.title) {
        if (page.desc) {
            accessibilityLabel = [NSString stringWithFormat:@"%@, %@", page.title, page.desc];
        } else {
            accessibilityLabel = page.title;
        }
    } else {
        accessibilityLabel = page.desc;
    }
    return accessibilityLabel;
}

- (void)appendCloseViewAtXIndex:(CGFloat *)xIndex {
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0.f, self.bounds.size.width, self.bounds.size.height)];
    closeView.tag = 124;
    [self.scrollView addSubview:closeView];

    *xIndex += self.scrollView.bounds.size.width;
}

- (void)removeCloseViewAtXIndex:(CGFloat *)xIndex {
    UIView *closeView = [self.scrollView viewWithTag:124];
    if (closeView) {
        [closeView removeFromSuperview];
    }

    *xIndex -= self.scrollView.bounds.size.width;
}

- (void)buildTitleView {
    if (!self.titleView.superview) {
        [self addSubview:self.titleView];
    }

    if (self.titleViewConstraints.count) {
        [self removeConstraints:self.titleViewConstraints];
        [self.titleViewConstraints removeAllObjects];
    }

    NSDictionary *views = @{@"titleView": self.titleView};
    NSDictionary *metrics = @{@"titleViewTopPadding": @(self.titleViewY),
                              @"titleViewHeight": @(self.titleView.frame.size.height),
                              @"titleViewWidth": @(self.titleView.frame.size.width)};

    [self.titleViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(titleViewTopPadding@250)-[titleView(titleViewHeight)]"
                                                                                           options:NSLayoutFormatAlignAllLeft
                                                                                           metrics:metrics
                                                                                             views:views]];
    [self.titleViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleView(titleViewWidth)]"
                                                                                           options:NSLayoutFormatAlignAllTop
                                                                                           metrics:metrics
                                                                                             views:views]];
    [self.titleViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.titleView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.f]];

    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:self.titleViewConstraints];

    [self.titleView setNeedsUpdateConstraints];
}

- (void)buildFooterView {
    if (!self.pageControl.superview) {
        [self insertSubview:self.pageControl aboveSubview:self.scrollView];
    }

    if (!self.skipButton.superview) {
        [self insertSubview:self.skipButton aboveSubview:self.scrollView];
    }

    [self.pageControl.superview bringSubviewToFront:self.pageControl];
    [self.skipButton.superview bringSubviewToFront:self.skipButton];

    if (self.footerConstraints.count) {
        [self removeConstraints:self.footerConstraints];
        [self.footerConstraints removeAllObjects];
    }

    CGFloat pageControlHeight = self.pageControl.frame.size.height > 0 ? self.pageControl.frame.size.height: PAGE_CTRL_DEFAULT_HEIGHT;
    CGFloat skipButtonWidth = self.skipButton.frame.size.width > 0 ? self.skipButton.frame.size.width: SKIP_BTN_DEFAULT_WIDTH;
    CGFloat skipButtonHeight = self.skipButton.frame.size.height > 0 ? self.skipButton.frame.size.height: SKIP_BTN_DEFAULT_HEIGHT;

    NSDictionary *views = @{@"pageControl": self.pageControl, @"skipButton": self.skipButton};
    NSDictionary *metrics = @{@"pageControlBottomPadding": @(self.pageControlY - pageControlHeight),
                              @"pageControlHeight": @(pageControlHeight),
                              @"skipButtonBottomPadding": @(self.skipButtonY - skipButtonHeight),
                              @"skipButtonSideMargin": @(self.skipButtonSideMargin),
                              @"skipButtonWidth": @(skipButtonWidth)};

    [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pageControl]-|"
                                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                                        metrics:metrics
                                                                                          views:views]];
    [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl(pageControlHeight)]-(pageControlBottomPadding@250)-|"
                                                                                        options:NSLayoutFormatAlignAllBottom
                                                                                        metrics:metrics
                                                                                          views:views]];

    if (self.skipButton && !self.skipButton.hidden) {
        if (self.skipButtonAlignment == EAViewAlignmentCenter) {
            [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[skipButton(skipButtonWidth)]"
                                                                                                options:NSLayoutFormatAlignAllTop
                                                                                                metrics:metrics
                                                                                                  views:views]];
            [self.footerConstraints addObject:[NSLayoutConstraint constraintWithItem:self.skipButton
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.f]];
        } else if (self.skipButtonAlignment == EAViewAlignmentLeft) {
            [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(skipButtonSideMargin)-[skipButton]"
                                                                                                options:NSLayoutFormatAlignAllLeft
                                                                                                metrics:metrics
                                                                                                  views:views]];
        } else if (self.skipButtonAlignment == EAViewAlignmentRight) {
            [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[skipButton]-(skipButtonSideMargin)-|"
                                                                                                options:NSLayoutFormatAlignAllRight
                                                                                                metrics:metrics
                                                                                                  views:views]];
        }

        if (self.skipButtonY == EA_EMPTY_PROPERTY) {
            [self.footerConstraints addObject:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.skipButton
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0
                                                                            constant:0.f]];
        } else {
            [self.footerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[skipButton]-(skipButtonBottomPadding)-|"
                                                                                                options:NSLayoutFormatAlignAllBottom
                                                                                                metrics:metrics
                                                                                                  views:views]];
        }
    }

    [self addConstraints:self.footerConstraints];

    [self.pageControl setNeedsUpdateConstraints];
    [self.skipButton setNeedsUpdateConstraints];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(EARestrictedScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(intro:pageStartScrolling:withIndex:)] && self.currentPageIndex < [self.pages count]) {
        [self.delegate intro:self pageStartScrolling:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(EARestrictedScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
    if ([self.delegate respondsToSelector:@selector(intro:pageEndScrolling:withIndex:)] && self.currentPageIndex < [self.pages count]) {
        [self.delegate intro:self pageEndScrolling:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(EARestrictedScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
}

- (void)scrollViewDidScroll:(EARestrictedScrollView *)scrollView {
    if (!self.scrollingEnabled) {
        return;
    }

    CGFloat offset = scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    NSUInteger page = (NSUInteger)(offset);

    if (page == (_pages.count - 1) && self.swipeToExit) {
        self.alpha = ((self.scrollView.bounds.size.width * _pages.count) - self.scrollView.contentOffset.x) / self.scrollView.bounds.size.width;
    } else {
        if ([self pageForIndex:page]) {
            self.alpha = 1.f;
        }
    }

    [self crossDissolveForOffset:offset];

    if (self.visiblePageIndex < _pages.count) {
        self.pageControl.currentPage = self.visiblePageIndex;

        [self makePanelVisibleAtIndex:self.visiblePageIndex];
    }

    if ([self.delegate respondsToSelector:@selector(intro:didScrollWithOffset:)]) {
        [self.delegate intro:self didScrollWithOffset:offset];
    }
}

CGFloat easeOutValue(CGFloat value) {
    CGFloat inverse = value - 1.f;
    return (CGFloat) (1.f + inverse * inverse * inverse);
}

- (void)crossDissolveForOffset:(CGFloat)offset {
    NSUInteger page = (NSUInteger)(offset);
    CGFloat alphaValue = offset - page;

    if (alphaValue < 0 && self.visiblePageIndex == 0){
        self.pageBgBack.image = nil;
        return;
    }

    self.pageBgFront.alpha = [self alphaForPageIndex:page];
    self.pageBgFront.image = [self bgImageForPage:page];
    self.pageBgFront.backgroundColor = [self bgColorForPage:page];
    self.pageBgBack.alpha = 0.f;
    self.pageBgBack.image = [self bgImageForPage:page + 1];
    self.pageBgBack.backgroundColor = [self bgColorForPage:page + 1];

    CGFloat backLayerAlpha = alphaValue;
    CGFloat frontLayerAlpha = (1 - alphaValue);

    if (self.easeOutCrossDisolves) {
        backLayerAlpha = easeOutValue(backLayerAlpha);
        frontLayerAlpha = easeOutValue(frontLayerAlpha);
    }

    self.pageBgBack.alpha = MIN(backLayerAlpha, [self alphaForPageIndex:page + 1]);
    self.pageBgFront.alpha = MIN(frontLayerAlpha, [self alphaForPageIndex:page]);

    if (self.titleView) {
        if ([self showTitleViewForPage:page] && [self showTitleViewForPage:page + 1]) {
            [self.titleView setAlpha:1.f];
        } else if (![self showTitleViewForPage:page] && ![self showTitleViewForPage:page + 1]) {
            [self.titleView setAlpha:0.f];
        } else if ([self showTitleViewForPage:page]) {
            [self.titleView setAlpha:(1 - alphaValue)];
        } else {
            [self.titleView setAlpha:alphaValue];
        }
    }

    if (self.skipButton && self.showSkipButtonOnlyOnLastPage) {
        if (page < (long)[self.pages count] - 2) {
            [self.skipButton setAlpha:0.f];
        } else if (page == [self.pages count] - 1) {
            [self.skipButton setAlpha:(1 - alphaValue)];
        } else {
            [self.skipButton setAlpha:alphaValue];
        }
    }
}

#pragma mark - UIView lifecycle calls

- (void)layoutSubviews {
    [super layoutSubviews];

    // Get amount of pages:
    NSInteger numberOfPages = _pages.count;

    // Increase with 1 page when feature enabled:
    if (self.swipeToExit) {
        numberOfPages = numberOfPages + 1;
    }

    // Descrease to limited index when scrolling is restricted:
    if (self.limitPageIndex != -1) {
        numberOfPages = self.limitPageIndex + 1;
    }

    // Adjust contentSize of ScrollView:
    CGSize newContentSize = CGSizeMake(numberOfPages * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    if (self.scrollView.contentOffset.x > newContentSize.width) {
        CGPoint newOffset = self.scrollView.contentOffset;
        if (self.swipeToExit) {
            newOffset.x = newContentSize.width - (self.scrollView.bounds.size.width * 2);
        } else {
            newOffset.x = newContentSize.width - self.scrollView.bounds.size.width;
        }
        self.scrollView.contentOffset = newOffset;
    }
    self.scrollView.contentSize = newContentSize;

    // Adjust frame of each page:
    NSUInteger i = 0;
    for (EAIntroPage *page in _pages) {
        page.pageView.frame = CGRectMake(i * self.scrollView.bounds.size.width, 0.f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        i++;
    }

    // Adjust scrolling to fit resized page:
    CGFloat offset = self.currentPageIndex * self.scrollView.bounds.size.width;
    CGRect pageRect = CGRectMake(offset, 0.f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView scrollRectToVisible:pageRect animated:NO];

    // Adjust restricted scroll area:
    if (!self.scrollingEnabled) {
        self.scrollView.restrictionArea = CGRectMake(self.visiblePageIndex * self.bounds.size.width,
                                                     0.f,
                                                     self.scrollView.bounds.size.width,
                                                     self.scrollView.bounds.size.height);
    } else {
        self.scrollView.restrictionArea = CGRectZero;
    }
}

#pragma mark - Custom setters

- (void)setScrollingEnabled:(BOOL)scrollingEnabled {
    if (!scrollingEnabled) {
        self.scrollView.restrictionArea = CGRectMake(self.visiblePageIndex * self.bounds.size.width,
                                                     0.f,
                                                     self.scrollView.bounds.size.width,
                                                     self.scrollView.bounds.size.height);
    } else {
        self.scrollView.restrictionArea = CGRectZero;
    }

    _scrollingEnabled = scrollingEnabled;
}

- (void)setPages:(NSArray<EAIntroPage *> *)pages {
    _pages = [pages copy];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;

    _currentPageIndex = 0;
    self.pageControl.numberOfPages = _pages.count;
    self.pageControl.currentPage = self.currentPageIndex;

    [self buildScrollView];
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.bgImageView.image = _bgImage;

    [self setNeedsDisplay];
}

- (void)setBgViewContentMode:(UIViewContentMode)bgViewContentMode {
    _bgViewContentMode = bgViewContentMode;
    self.bgImageView.contentMode = bgViewContentMode;
    self.pageBgBack.contentMode = bgViewContentMode;
    self.pageBgFront.contentMode = bgViewContentMode;

    [self setNeedsDisplay];
}

- (void)setSwipeToExit:(BOOL)swipeToExit {
    if (swipeToExit != _swipeToExit) {
        CGFloat contentXIndex = self.scrollView.contentSize.width;
        if (swipeToExit) {
            [self appendCloseViewAtXIndex:&contentXIndex];
        } else {
            [self removeCloseViewAtXIndex:&contentXIndex];
        }
        self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.bounds.size.height);
    }
    _swipeToExit = swipeToExit;
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;

    if ([_titleView respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]) {
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    }

    CGFloat offset = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    [self crossDissolveForOffset:offset];

    [self buildTitleView];

    [self setNeedsDisplay];
}

- (void)setTitleViewY:(CGFloat)titleViewY {
    _titleViewY = titleViewY;

    [self buildTitleView];

    [self setNeedsDisplay];
}

- (void)setPageControl:(UIPageControl *)pageControl {
    if (!pageControl) {
        _pageControl.hidden = YES;
        return;
    }

    [_pageControl removeFromSuperview];
    _pageControl = pageControl;
    [self applyDefaultsToPageControl];

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setPageControlY:(CGFloat)pageControlY {
    _pageControlY = pageControlY;

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setSkipButton:(UIButton *)skipButton {
    if (!skipButton) {
        _skipButton.hidden = YES;
        return;
    }

    [_skipButton removeFromSuperview];
    _skipButton = skipButton;
    _skipButton.hidden = NO;
    [self applyDefaultsToSkipButton];

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setSkipButtonY:(CGFloat)skipButtonY {
    _skipButtonY = skipButtonY;

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setSkipButtonSideMargin:(CGFloat)skipButtonSideMargin {
    _skipButtonSideMargin = skipButtonSideMargin;

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setSkipButtonAlignment:(EAViewAlignment)skipButtonAlignment {
    _skipButtonAlignment = skipButtonAlignment;

    [self buildFooterView];

    [self setNeedsDisplay];
}

- (void)setShowSkipButtonOnlyOnLastPage:(BOOL)showSkipButtonOnlyOnLastPage {
    _showSkipButtonOnlyOnLastPage = showSkipButtonOnlyOnLastPage;

    CGFloat offset = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    [self crossDissolveForOffset:offset];
}

- (void)setUseMotionEffects:(BOOL)useMotionEffects {
    if (_useMotionEffects == useMotionEffects) {
        return;
    }
    _useMotionEffects = useMotionEffects;

    if (useMotionEffects) {
        [self addMotionEffectsOnBg];
    } else {
        [self removeMotionEffectsOnBg];
    }
}

- (void)setMotionEffectsRelativeValue:(CGFloat)motionEffectsRelativeValue {
    _motionEffectsRelativeValue = motionEffectsRelativeValue;
    if (self.useMotionEffects) {
        [self addMotionEffectsOnBg];
    }
}

#pragma mark - Motion effects actions

- (void)addMotionEffectsOnBg {
    if (![self respondsToSelector:@selector(setMotionEffects:)]) {
        return;
    }

    CGRect parallaxFrame = CGRectMake(-self.motionEffectsRelativeValue,
                                      -self.motionEffectsRelativeValue,
                                      self.bounds.size.width + (self.motionEffectsRelativeValue * 2),
                                      self.bounds.size.height + (self.motionEffectsRelativeValue * 2));
    [self.pageBgFront setFrame:parallaxFrame];
    [self.pageBgBack setFrame:parallaxFrame];
    [self.bgImageView setFrame:parallaxFrame];

    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(self.motionEffectsRelativeValue);
    verticalMotionEffect.maximumRelativeValue = @(-self.motionEffectsRelativeValue);

    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(self.motionEffectsRelativeValue);
    horizontalMotionEffect.maximumRelativeValue = @(-self.motionEffectsRelativeValue);

    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

    // Add both effects to all background image views
    [UIView animateWithDuration:0.5 animations:^{
        [self.pageBgFront setMotionEffects:@[group]];
        [self.pageBgBack setMotionEffects:@[group]];
        [self.bgImageView setMotionEffects:@[group]];
    }];
}

- (void)removeMotionEffectsOnBg {
    if (![self respondsToSelector:@selector(removeMotionEffect:)]) {
        return;
    }

    [UIView animateWithDuration:0.5 animations:^{
        [self.pageBgFront removeMotionEffect:self.pageBgFront.motionEffects[0]];
        [self.pageBgBack removeMotionEffect:self.pageBgBack.motionEffects[0]];
        [self.bgImageView removeMotionEffect:self.bgImageView.motionEffects[0]];
    }];
}

#pragma mark - Actions

- (void)showFullscreen {
    [self showFullscreenWithAnimateDuration:0.3 andInitialPageIndex:0];
}

- (void)showFullscreenWithAnimateDuration:(CGFloat)duration {
    [self showFullscreenWithAnimateDuration:duration andInitialPageIndex:0];
}

- (void)showFullscreenWithAnimateDuration:(CGFloat)duration andInitialPageIndex:(NSUInteger)initialPageIndex {
    UIView *selectedView;

    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;

        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            selectedView = window;
            break;
        }
    }

    [self showInView:selectedView animateDuration:duration withInitialPageIndex:initialPageIndex];
}

- (void)showInView:(UIView *)view {
    [self showInView:view animateDuration:0.3 withInitialPageIndex:0];
}

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration {
    [self showInView:view animateDuration:duration withInitialPageIndex:0];
}

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration withInitialPageIndex:(NSUInteger)initialPageIndex {
    if (![self pageForIndex:initialPageIndex]) {
        NSLog(@"Wrong initialPageIndex received: %ld",(long)initialPageIndex);
        return;
    }

	self.skipped = NO;
    _currentPageIndex = initialPageIndex;
    self.alpha = 0.f;

    if (self.superview != view) {
        [view addSubview:self];
    } else {
        [view bringSubviewToFront:self];
    }

    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        EAIntroPage *currentPage = _pages[self.currentPageIndex];
        if (currentPage.onPageDidAppear) currentPage.onPageDidAppear();

        if ([(id)self.delegate respondsToSelector:@selector(intro:pageAppeared:withIndex:)]) {
            [self.delegate intro:self pageAppeared:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
        }
    }];
}

- (void)hideWithFadeOutDuration:(CGFloat)duration {
    if ([self.delegate respondsToSelector:@selector(introWillFinish:wasSkipped:)]) {
        [self.delegate introWillFinish:self wasSkipped:self.skipped];
    }

    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished){
		[self finishIntroductionAndRemoveSelf];
	}];
}

- (void)scrollToPageForIndex:(NSUInteger)newPageIndex animated:(BOOL)animated {
    if (![self pageForIndex:newPageIndex]) {
        NSLog(@"Wrong newPageIndex received: %ld",(long)newPageIndex);
        return;
    }

    CGFloat offset = newPageIndex * self.scrollView.bounds.size.width;
    CGRect pageRect = CGRectMake(offset, 0.f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView scrollRectToVisible:pageRect animated:animated];

    if (!animated) {
        [self scrollViewDidScroll:self.scrollView];
        [self scrollViewDidEndScrollingAnimation:self.scrollView];
    }
}

- (void)handleBackgroundTap:(UIGestureRecognizer *)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self goToNext:tapRecognizer];
    }
}

- (IBAction)goToNext:(id)sender {
    if (!self.tapToNext) {
        return;
    }
    if (self.currentPageIndex + 1 >= [self.pages count]) {
        [self hideWithFadeOutDuration:0.3];
    } else {
        // Just scroll to the new page.
        // After scrolling ends, we call -checkIndexForScrollView:, which itself sets the new currentPageIndex.
        [self scrollToPageForIndex:self.currentPageIndex + 1 animated:YES];
    }
}

- (void)setLimitPageIndex:(NSInteger)limitPageIndex {
    _limitPageIndex = limitPageIndex;

    if (limitPageIndex < 0 || limitPageIndex >= self.pages.count) {
        _limitPageIndex = -1;
        self.scrollingEnabled = YES;
        return;
    } else {
        self.scrollView.restrictionArea = CGRectMake(0.f,
                                                     0.f,
                                                     (self.limitPageIndex + 1) * self.scrollView.bounds.size.width,
                                                     self.scrollView.bounds.size.height);
    }
}

@end
