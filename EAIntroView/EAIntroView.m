//
//  EAIntroView.m
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import "EAIntroView.h"

@interface EAIntroView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *pageBgBack;
@property (nonatomic, strong) UIImageView *pageBgFront;

@property(nonatomic, strong) NSLayoutConstraint *pageControlYConstraint;

@end

@interface EAIntroPage()

@property(nonatomic, strong, readwrite) UIView *pageView;

@end


@implementation EAIntroView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:frame pages:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:self.frame pages:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyDefaultsToSelfDuringInitializationWithframe:self.frame pages:pagesArray];
    }
    return self;
}

#pragma mark - Private

- (void)applyDefaultsToSelfDuringInitializationWithframe:(CGRect)frame pages:(NSArray *)pagesArray {
    self.swipeToExit = YES;
    self.easeOutCrossDisolves = YES;
    self.hideOffscreenPages = YES;
    self.titleViewY = 20.0f;
    self.pageControlY = 60.0f;
    self.bgViewContentMode = UIViewContentModeScaleAspectFill;
    self.motionEffectsRelativeValue = 40.0f;
    _pages = [pagesArray copy];
    [self buildUI];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)applyDefaultsToBackgroundImageView:(UIImageView *)backgroundImageView {
    backgroundImageView.backgroundColor = [UIColor clearColor];
    backgroundImageView.contentMode = self.bgViewContentMode;
    backgroundImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)makePanelVisibleAtIndex:(NSInteger)panelIndex{
    [UIView animateWithDuration:0.3 animations:^{
        for (int idx = 0; idx < _pages.count; idx++) {
            if (idx == panelIndex) {
                [[self viewForPageIndex:idx] setAlpha:1];
            } else {
                if(!self.hideOffscreenPages) {
                    [[self viewForPageIndex:idx] setAlpha:0];
                }
            }
        }
    }];
}

- (UIView *)viewForPageIndex:(NSInteger)idx {
    return ((EAIntroPage *)_pages[idx]).pageView;
}

- (BOOL)showTitleViewForPage:(NSInteger)idx {
    if(idx >= _pages.count || idx < 0)
        return NO;
    
    return ((EAIntroPage *)_pages[idx]).showTitleView;
}

- (void)showPanelAtPageControl {
    [self makePanelVisibleAtIndex:self.currentPageIndex];
    
    [self setCurrentPageIndex:self.pageControl.currentPage animated:YES];
}

- (void)checkIndexForScrollView:(UIScrollView *)scrollView {
    NSInteger newPageIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2)/self.scrollView.frame.size.width;
    [self notifyDelegateWithPreviousPage:self.currentPageIndex andCurrentPage:newPageIndex];
    _currentPageIndex = newPageIndex;
    
    if (self.currentPageIndex == (_pages.count)) {
        
        //if run here, it means you can't  call _pages[self.currentPageIndex],
        //to be safe, set to the biggest index
        _currentPageIndex = _pages.count - 1;
        
        [self finishIntroductionAndRemoveSelf];
    }
}

- (void)finishIntroductionAndRemoveSelf {
	if ([(id)self.delegate respondsToSelector:@selector(introDidFinish:)]) {
		[self.delegate introDidFinish:self];
	}
    
    //prevent last page flicker on disappearing
    self.alpha = 0;
    
    //Calling removeFromSuperview from scrollViewDidEndDecelerating: method leads to crash on iOS versions < 7.0.
    //removeFromSuperview should be called after a delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}

- (void)skipIntroduction {
    [self hideWithFadeOutDuration:0.3];
}

#pragma mark - Properties

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.accessibilityIdentifier = @"intro_scroll";
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _scrollView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_bgImageView];
    }
    return _bgImageView;
}

- (UIImageView *)pageBgBack {
    if (!_pageBgBack) {
        _pageBgBack = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_pageBgBack];
        _pageBgBack.alpha = 0;
    }
    return _pageBgBack;
}

- (UIImageView *)pageBgFront {
    if (!_pageBgFront) {
        _pageBgFront = [[UIImageView alloc] initWithFrame:self.frame];
        [self applyDefaultsToBackgroundImageView:_pageBgFront];
        _pageBgFront.alpha = 0;
    }
    return _pageBgFront;
}

#pragma mark - UI building

- (void)buildUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self buildBackgroundImage];
    [self buildScrollView];
    
    [self buildFooterView];
    
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.skipButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

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
    for (int idx = 0; idx < _pages.count; idx++) {
        EAIntroPage *page = _pages[idx];
        page.pageView = [self viewForPage:page atXIndex:&contentXIndex];
        [self.scrollView addSubview:page.pageView];
        if(page.onPageDidLoad) page.onPageDidLoad();
    }
    
    [self makePanelVisibleAtIndex:0];
    
    if (self.swipeToExit) {
        [self appendCloseViewAtXIndex:&contentXIndex];
    }
    
    [self insertSubview:self.scrollView aboveSubview:self.pageBgFront];
    self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.frame.size.height);
    
    self.pageBgBack.alpha = 0;
    self.pageBgBack.image = [self bgForPage:1];
    self.pageBgFront.alpha = 1;
    self.pageBgFront.image = [self bgForPage:0];
}

- (UIView *)viewForPage:(EAIntroPage *)page atXIndex:(CGFloat *)xIndex {
    
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    *xIndex += self.scrollView.frame.size.width;
    
    if(page.customView) {
        page.customView.frame = pageView.bounds;
        [pageView addSubview:page.customView];
        return pageView;
    }
    
    UIButton *tapToNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapToNextButton.frame = pageView.bounds;
    [tapToNextButton addTarget:self action:@selector(goToNext:) forControlEvents:UIControlEventTouchUpInside];
    [pageView addSubview:tapToNextButton];
    
    if(page.titleIconView) {
        UIView *titleImageView = page.titleIconView;
        CGRect rect1 = titleImageView.frame;
        rect1.origin.x = (self.scrollView.frame.size.width - rect1.size.width)/2;
        rect1.origin.y = page.titleIconPositionY;
        titleImageView.frame = rect1;
        titleImageView.tag = kTitleImageViewTag;
        
        [pageView addSubview:titleImageView];
    }
    
    if(page.title.length) {
        CGFloat titleHeight;
        
        if ([page.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:page.title attributes:@{ NSFontAttributeName: page.titleFont }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.scrollView.frame.size.width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            titleHeight = ceilf(rect.size.height);
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            titleHeight = [page.title sizeWithFont:page.titleFont constrainedToSize:CGSizeMake(self.scrollView.frame.size.width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
        }
        
        CGRect titleLabelFrame = CGRectMake(10, self.frame.size.height - page.titlePositionY, self.scrollView.frame.size.width - 20, titleHeight);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = page.title;
        titleLabel.font = page.titleFont;
        titleLabel.textColor = page.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = kTitleLabelTag;
        
        [pageView addSubview:titleLabel];
    }
    
    if([page.desc length]) {
        CGRect descLabelFrame;
        
        if(page.descWidth != 0) {
            descLabelFrame = CGRectMake((self.frame.size.width - page.descWidth)/2, self.frame.size.height - page.descPositionY, page.descWidth, 500);
        } else {
            descLabelFrame = CGRectMake(0, self.frame.size.height - page.descPositionY, self.scrollView.frame.size.width, 500);
        }
        
        UITextView *descLabel = [[UITextView alloc] initWithFrame:descLabelFrame];
        descLabel.text = page.desc;
        descLabel.scrollEnabled = NO;
        descLabel.font = page.descFont;
        descLabel.textColor = page.descColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.userInteractionEnabled = NO;
        descLabel.tag = kDescLabelTag;
        
        [pageView addSubview:descLabel];
    }
    
    if(page.subviews) {
        for (UIView *subV in page.subviews) {
            [pageView addSubview:subV];
        }
    }
    
    pageView.accessibilityLabel = [NSString stringWithFormat:@"intro_page_%lu",(unsigned long)[self.pages indexOfObject:page]];
    
    return pageView;
}

- (void)appendCloseViewAtXIndex:(CGFloat*)xIndex {
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, self.frame.size.height)];
    closeView.tag = 124;
    [self.scrollView addSubview:closeView];
    
    *xIndex += self.scrollView.frame.size.width;
}

- (void)removeCloseViewAtXIndex:(CGFloat*)xIndex {
    UIView *closeView = [self.scrollView viewWithTag:124];
    if(closeView) {
        [closeView removeFromSuperview];
    }
    
    *xIndex -= self.scrollView.frame.size.width;
}

- (void)buildFooterView {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.pageControlY, self.frame.size.width, 20)];
    
    self.pageControl.defersCurrentPageDisplay = YES;
    
    self.pageControl.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = _pages.count;
    [self addSubview:self.pageControl];
    
    self.skipButton = [[UIButton alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width - 80, self.pageControl.frame.origin.y - ((30 - self.pageControl.frame.size.height)/2), 80, 30)];
    [self.skipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    
    if ([self respondsToSelector:@selector(addConstraint:)]) {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        //store Y constraint
        //at launch - page control centered with skip button by Y. If Y is set manually, Y constraint turns to bottom constraint
        self.pageControlYConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.skipButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraint:self.pageControlYConstraint];
        
        self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([(id)self.delegate respondsToSelector:@selector(intro:pageStartScrolling:withIndex:)] && self.currentPageIndex < [self.pages count]) {
        [self.delegate intro:self pageStartScrolling:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
    if ([(id)self.delegate respondsToSelector:@selector(intro:pageEndScrolling:withIndex:)] && self.currentPageIndex < [self.pages count]) {
        [self.delegate intro:self pageEndScrolling:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkIndexForScrollView:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.visiblePageIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2)/self.scrollView.frame.size.width;
    
    float offset = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)(offset);
    
    if (page == (_pages.count - 1) && self.swipeToExit) {
        self.alpha = ((self.scrollView.frame.size.width*_pages.count)-self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
    } else {
        [self crossDissolveForOffset:offset];
    }
    
    if (self.visiblePageIndex < _pages.count) {
        self.pageControl.currentPage = self.visiblePageIndex;
        
        [self makePanelVisibleAtIndex:self.visiblePageIndex];
    }
}

float easeOutValue(float value) {
    float inverse = value - 1.0;
    return 1.0 + inverse * inverse * inverse;
}

- (void)crossDissolveForOffset:(float)offset {
    NSInteger page = (NSInteger)(offset);
    float alphaValue = offset - page;
    
    if (alphaValue < 0 && self.visiblePageIndex == 0){
        self.pageBgBack.image = nil;
        self.pageBgFront.alpha = (1 + alphaValue);
        return;
    }
    
    self.pageBgFront.alpha = 1;
    self.pageBgFront.image = [self bgForPage:page];
    self.pageBgBack.alpha = 0;
    self.pageBgBack.image = [self bgForPage:page+1];
    
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    if (self.easeOutCrossDisolves) {
        backLayerAlpha = easeOutValue(backLayerAlpha);
        frontLayerAlpha = easeOutValue(frontLayerAlpha);
    }
    
    self.pageBgBack.alpha = backLayerAlpha;
    self.pageBgFront.alpha = frontLayerAlpha;
    
    if(self.titleView) {
        if([self showTitleViewForPage:page] && [self showTitleViewForPage:page+1]) {
            [self.titleView setAlpha:1.0];
        } else if(![self showTitleViewForPage:page] && ![self showTitleViewForPage:page+1]) {
            [self.titleView setAlpha:0.0];
        } else if([self showTitleViewForPage:page]) {
            [self.titleView setAlpha:(1 - alphaValue)];
        } else {
            [self.titleView setAlpha:alphaValue];
        }
    }
    
    if(self.skipButton) {
        if(!self.showSkipButtonOnlyOnLastPage) {
            [self.skipButton setAlpha:1.0];
        } else if(page < (long)[self.pages count] - 2) {
            [self.skipButton setAlpha:0.0];
        } else if(page == [self.pages count] - 1) {
            [self.skipButton setAlpha:(1 - alphaValue)];
        } else {
            [self.skipButton setAlpha:alphaValue];
        }
    }
}

- (UIImage *)bgForPage:(NSInteger)idx {
    if(idx >= _pages.count || idx < 0)
        return nil;
    
    return ((EAIntroPage *)_pages[idx]).bgImage;
}

#pragma mark - Custom setters

- (void)notifyDelegateWithPreviousPage:(NSInteger)previousPageIndex andCurrentPage:(NSInteger)currentPageIndex {
    if(currentPageIndex!=_currentPageIndex && currentPageIndex < _pages.count) {
        EAIntroPage* previousPage = _pages[previousPageIndex];
        EAIntroPage* currentPage = _pages[currentPageIndex];
        if(previousPage.onPageDidDisappear) previousPage.onPageDidDisappear();
        if(currentPage.onPageDidAppear) currentPage.onPageDidAppear();
        
        if ([(id)self.delegate respondsToSelector:@selector(intro:pageAppeared:withIndex:)]) {
            [self.delegate intro:self pageAppeared:_pages[currentPageIndex] withIndex:currentPageIndex];
        }
    }
}

- (void)setPages:(NSArray *)pages {
    _pages = [pages copy];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self buildScrollView];
    self.pageControl.numberOfPages = _pages.count;
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.bgImageView.image = _bgImage;
}

- (void)setBgViewContentMode:(UIViewContentMode)bgViewContentMode {
    _bgViewContentMode = bgViewContentMode;
    self.bgImageView.contentMode = bgViewContentMode;
    self.pageBgBack.contentMode = bgViewContentMode;
    self.pageBgFront.contentMode = bgViewContentMode;
}

- (void)setSwipeToExit:(bool)swipeToExit {
    if (swipeToExit != _swipeToExit) {
        CGFloat contentXIndex = self.scrollView.contentSize.width;
        if(swipeToExit) {
            [self appendCloseViewAtXIndex:&contentXIndex];
        } else {
            [self removeCloseViewAtXIndex:&contentXIndex];
        }
        self.scrollView.contentSize = CGSizeMake(contentXIndex, self.scrollView.frame.size.height);
    }
    _swipeToExit = swipeToExit;
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;
    _titleView.frame = CGRectMake((self.frame.size.width-_titleView.frame.size.width)/2, self.titleViewY, _titleView.frame.size.width, _titleView.frame.size.height);
    
    float offset = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self crossDissolveForOffset:offset];
    
    [self addSubview:_titleView];
}

- (void)setTitleViewY:(CGFloat)titleViewY {
    _titleViewY = titleViewY;
    _titleView.frame = CGRectMake((self.frame.size.width-_titleView.frame.size.width)/2, self.titleViewY, _titleView.frame.size.width, _titleView.frame.size.height);
}

- (void)setPageControl:(UIPageControl *)pageControl {
    [_pageControl removeFromSuperview];
    _pageControl = pageControl;
    [self addSubview:_pageControl];
}

- (void)setPageControlY:(CGFloat)pageControlY {
    _pageControlY = pageControlY;
    self.pageControl.frame = CGRectMake(self.pageControl.frame.origin.y, self.frame.size.width - pageControlY, self.frame.size.width, self.pageControl.frame.size.height);
    
    if (self.pageControlYConstraint) {
        [self removeConstraint:self.pageControlYConstraint];
        if (self.pageControlYConstraint.firstAttribute != NSLayoutAttributeBottom || self.pageControlYConstraint.secondAttribute != NSLayoutAttributeBottom) {
            self.pageControlYConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-pageControlY];
        } else {
            self.pageControlYConstraint.constant = -pageControlY;
        }
        [self addConstraint:self.pageControlYConstraint];
    }
}

- (void)setSkipButton:(UIButton *)skipButton {
    [_skipButton removeFromSuperview];
    _skipButton = skipButton;
    [_skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_skipButton];
}

- (void)setShowSkipButtonOnlyOnLastPage:(bool)showSkipButtonOnlyOnLastPage {
    _showSkipButtonOnlyOnLastPage = showSkipButtonOnlyOnLastPage;
    
    float offset = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self crossDissolveForOffset:offset];
}

- (void)setUseMotionEffects:(bool)useMotionEffects {
    if(_useMotionEffects == useMotionEffects) {
        return;
    }
    _useMotionEffects = useMotionEffects;
    
    if(useMotionEffects) {
        [self addMotionEffectsOnBg];
    } else {
        [self removeMotionEffectsOnBg];
    }
}

- (void)setMotionEffectsRelativeValue:(CGFloat)motionEffectsRelativeValue {
    _motionEffectsRelativeValue = motionEffectsRelativeValue;
    if(self.useMotionEffects) {
        [self addMotionEffectsOnBg];
    }
}

#pragma mark - Motion effects actions

- (void)addMotionEffectsOnBg {
    if(![self respondsToSelector:@selector(setMotionEffects:)]) {
        return;
    }
    
    CGRect parallaxFrame = CGRectMake(-self.motionEffectsRelativeValue, -self.motionEffectsRelativeValue, self.frame.size.width + (self.motionEffectsRelativeValue * 2), self.frame.size.height + (self.motionEffectsRelativeValue * 2));
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
    [UIView animateWithDuration:0.5f animations:^{
        [self.pageBgFront setMotionEffects:@[group]];
        [self.pageBgBack setMotionEffects:@[group]];
        [self.bgImageView setMotionEffects:@[group]];
    }];
}

- (void)removeMotionEffectsOnBg {
    if(![self respondsToSelector:@selector(removeMotionEffect:)]) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.pageBgFront removeMotionEffect:self.pageBgFront.motionEffects[0]];
        [self.pageBgBack removeMotionEffect:self.pageBgBack.motionEffects[0]];
        [self.bgImageView removeMotionEffect:self.bgImageView.motionEffects[0]];
    }];
}

#pragma mark - Actions

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration {
    self.alpha = 0;
    _currentPageIndex = 0;
    self.scrollView.contentOffset = CGPointZero;
    [view addSubview:self];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        EAIntroPage* currentPage = _pages[self.currentPageIndex];
        if(currentPage.onPageDidAppear) currentPage.onPageDidAppear();
        
        if ([(id)self.delegate respondsToSelector:@selector(intro:pageAppeared:withIndex:)]) {
            [self.delegate intro:self pageAppeared:_pages[self.currentPageIndex] withIndex:self.currentPageIndex];
        }
    }];
}

- (void)hideWithFadeOutDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
		[self finishIntroductionAndRemoveSelf];
	}];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    [self setCurrentPageIndex:currentPageIndex animated:NO];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated {
    if(currentPageIndex < 0 || currentPageIndex >= [self.pages count]) {
        NSLog(@"Wrong currentPageIndex received: %ld",(long)currentPageIndex);
        return;
    }
    
    float offset = currentPageIndex * self.scrollView.frame.size.width;
    CGRect pageRect = { .origin.x = offset, .origin.y = 0.0, .size.width = self.scrollView.frame.size.width, .size.height = self.scrollView.frame.size.height };
    [self.scrollView scrollRectToVisible:pageRect animated:animated];
}

- (IBAction)goToNext:(id)sender {
    if(!self.tapToNext) {
        return;
    }
    if(self.currentPageIndex + 1 >= [self.pages count]) {
        [self hideWithFadeOutDuration:0.3];
    } else {
        [self setCurrentPageIndex:self.currentPageIndex + 1 animated:YES];
    }
}

@end
