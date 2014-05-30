//
//  EAIntroPage.m
//
//  Copyright (c) 2013-2014 Evgeny Aleksandrov. License: MIT.

#import "EAIntroPage.h"

#define DEFAULT_DESCRIPTION_LABEL_SIDE_PADDING 25
#define DEFAULT_TITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
#define DEFAULT_LABEL_COLOR [UIColor whiteColor]
#define DEFAULT_DESCRIPTION_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]
#define DEFAULT_TITLE_IMAGE_Y_POSITION 50.0f
#define DEFAULT_TITLE_LABEL_Y_POSITION 160.0f
#define DEFAULT_DESCRIPTION_LABEL_Y_POSITION 140.0f

@interface EAIntroPage ()
@property(nonatomic, strong, readwrite) UIView *pageView;
@end

@implementation EAIntroPage

#pragma mark - Page lifecycle

+ (instancetype)page {
    EAIntroPage *newPage = [[self alloc] init];
    newPage.titleIconPositionY = DEFAULT_TITLE_IMAGE_Y_POSITION;
    newPage.titlePositionY  = DEFAULT_TITLE_LABEL_Y_POSITION;
    newPage.descPositionY   = DEFAULT_DESCRIPTION_LABEL_Y_POSITION;
    newPage.title = @"";
    newPage.titleFont = DEFAULT_TITLE_FONT;
    newPage.titleColor = DEFAULT_LABEL_COLOR;
    newPage.desc = @"";
    newPage.descFont = DEFAULT_DESCRIPTION_FONT;
    newPage.descColor = DEFAULT_LABEL_COLOR;
    newPage.showTitleView = YES;
    
    return newPage;
}

+ (instancetype)pageWithCustomView:(UIView *)customV {
    EAIntroPage *newPage = [[self alloc] init];
    newPage.customView = customV;
    return newPage;
}

+ (instancetype)pageWithCustomViewFromNibNamed:(NSString *)nibName {
    return [self pageWithCustomViewFromNibNamed:nibName bundle:[NSBundle mainBundle]];
}

+ (instancetype)pageWithCustomViewFromNibNamed:(NSString *)nibName bundle:(NSBundle*)aBundle {
    EAIntroPage *newPage = [[self alloc] init];
    newPage.customView = [[aBundle loadNibNamed:nibName owner:newPage options:nil] firstObject];
    return newPage;
}

@end
