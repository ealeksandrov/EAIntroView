//
//  EAIntroPage.m
//
//  Copyright (c) 2013 Evgeny Aleksandrov. License: MIT.

#import "EAIntroPage.h"

@interface EAIntroPage ()

@property(nonatomic, strong, readwrite) UIView *pageView;

@end

@implementation EAIntroPage

#pragma mark - Page lifecycle

+ (instancetype)page {
    EAIntroPage *newPage = [[super alloc] init];
    newPage.imgPositionY    = 50.0f;
    newPage.titlePositionY  = 160.0f;
    newPage.descPositionY   = 140.0f;
    newPage.title = @"";
    newPage.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    newPage.titleColor = [UIColor whiteColor];
    newPage.desc = @"";
    newPage.descFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    newPage.descColor = [UIColor whiteColor];
    newPage.showTitleView = YES;
    
    return newPage;
}

+ (instancetype)pageWithCustomView:(UIView *)customV {
    EAIntroPage *newPage = [[super alloc] init];
    newPage.customView = customV;
    
    return newPage;
}

+ (instancetype)pageWithCustomViewFromNibNamed:(NSString *)nibName {
    EAIntroPage *newPage = [[super alloc] init];
    newPage.customView = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
    
    return newPage;
}

- (void)pageDidLoad {
    //override
}

- (void)pageDidAppear {
    //override
}

- (void)pageDidDisappear {
    //override
}

@end
