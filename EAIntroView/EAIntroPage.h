//
//  EAIntroPage.h
//
//  Copyright (c) 2013 Evgeny Aleksandrov. License: MIT.

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)();

@interface EAIntroPage : NSObject

// background used for cross-dissolve
@property (nonatomic, strong) UIImage *bgImage;
// show or hide EAIntroView titleView on this page (default YES)
@property (nonatomic, assign) bool showTitleView;


// properties for default EAIntroPage layout
//
// title image Y position - from top of the screen
// title and description labels Y position - from bottom of the screen
// all items from subviews array will be added on page

/**
* The title view that is presented above the title label.
* The view can be a normal UIImageView or any other kind uf
* UIView. This allows to attach animated views as well.
*/
@property (nonatomic, strong) UIView * titleIconView;

@property (nonatomic, assign) CGFloat titleIconPositionY;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIFont *descFont;
@property (nonatomic, strong) UIColor *descColor;
@property (nonatomic, assign) CGFloat descPositionY;

/**
 * Defines the maximum allowed with for the description label.
 * This may become useful if you have a large screen and you
 * want to restrict the label's width so that it doesn't fill the whole screen.
 * If this property is set to a value greater than 0 it takes priority over
 * the descriptionLabelSidePadding property.
 **/
@property (nonatomic, assign) CGFloat descriptionLabelMaximumWidth;

/**
 * Defines the padding of the description label on the left and the right side to
 * its super view. If the descriptionLabelMaximumWidth property is set, setting the
 * side padding has no effect.
 **/
@property (nonatomic, assign) CGFloat descriptionLabelSidePadding;

@property (nonatomic, strong) NSArray *subviews;

@property (nonatomic,copy) VoidBlock onPageDidLoad;
@property (nonatomic,copy) VoidBlock onPageDidAppear;
@property (nonatomic,copy) VoidBlock onPageDidDisappear;


// if customView is set - all other default properties are ignored
@property (nonatomic, strong) UIView *customView;

@property(nonatomic, strong, readonly) UIView *pageView;

+ (instancetype)page;
+ (instancetype)pageWithCustomView:(UIView *)customV;
+ (instancetype)pageWithCustomViewFromNibNamed:(NSString *)nibName;

@end
