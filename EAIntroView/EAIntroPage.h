//
//  EAIntroPage.h
//
//  Copyright (c) 2013 Evgeny Aleksandrov. License: MIT.

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)();

@interface EAIntroPage : NSObject

// backround used for cross-dissolve
@property (nonatomic, strong) UIImage *bgImage;
// show or hide EAIntroView titleView on this page (default YES)
@property (nonatomic, assign) bool showTitleView;


// properties for default EAIntroPage layout
//
// title image Y position - from top of the screen
// title and description labels Y position - from bottom of the screen
// all items from subviews array will be added on page
@property (nonatomic, strong) UIImage *titleImage;

@property (nonatomic, assign) CGFloat imgPositionY;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIFont *descFont;
@property (nonatomic, strong) UIColor *descColor;
@property (nonatomic, assign) CGFloat descPositionY;
@property (nonatomic, assign) CGFloat descriptionLabelMaximumWidth;

@property (nonatomic, strong) NSArray *subviews;

@property (nonatomic,copy) VoidBlock onPageDidLoad;
@property (nonatomic,copy) VoidBlock onPageDidAppear;
@property (nonatomic,copy) VoidBlock onPageDidDisappear;


// if customView is set - all other default properties are ignored
@property (nonatomic, retain) UIView *customView;

@property(nonatomic, strong, readonly) UIView *pageView;

+ (instancetype)page;
+ (instancetype)pageWithCustomView:(UIView *)customV;
+ (instancetype)pageWithCustomViewFromNibNamed:(NSString *)nibName;

@end
