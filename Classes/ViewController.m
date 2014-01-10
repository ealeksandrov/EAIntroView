//
//  ViewController.m
//
//  Copyright (c) 2013 Evgeny Aleksandrov. License: MIT.

#import "ViewController.h"
#import "PageSubclass.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const sampleDesc1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDesc2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDesc3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDesc4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

@interface ViewController () {
    UIView *rootView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // using self.navigationController.view - to display EAIntroView above navigation bar
    rootView = self.navigationController.view;
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDesc2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleImage = [UIImage imageNamed:@"title2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDesc3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"title3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleImage = [UIImage imageNamed:@"title4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    intro.showSkipButtonOnLastPage = YES;
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithFixedTitleView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDesc2;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDesc3;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    intro.titleView = titleView;
    intro.titleViewY = 90;
    intro.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue

    [intro showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomPages {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 180;
    page2.desc = sampleDesc2;
    page2.descPositionY = 160;
    page2.titleImage = [UIImage imageNamed:@"title2"];
    page2.imgPositionY = 70;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page3.titlePositionY = 220;
    page3.desc = sampleDesc4;
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page3.descPositionY = 200;
    page3.titleImage = [UIImage imageNamed:@"title3"];
    page3.imgPositionY = 100;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    page4.titleImage = [UIImage imageNamed:@"title4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    intro.bgImage = [UIImage imageNamed:@"bg2"];
    
    intro.pageControlY = 250.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.0f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    intro.skipButton = btn;
    
    [intro setDelegate:self];
    [intro showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 30)];
    labelForPage2.text = @"Some custom view";
    labelForPage2.font = [UIFont systemFontOfSize:32];
    labelForPage2.textColor = [UIColor whiteColor];
    labelForPage2.backgroundColor = [UIColor clearColor];
    labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [viewForPage2 addSubview:labelForPage2];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:viewForPage2];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDesc3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"title3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleImage = [UIImage imageNamed:@"title4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithCustomViewFromNib {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage"];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDesc3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"title3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleImage = [UIImage imageNamed:@"title4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)showIntroWithSeparatePagesInitAndPageSubclass {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDesc1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    PageSubclass *page2 = [PageSubclass page];
    page2.title = @"This is page 2";
    page2.desc = sampleDesc2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleImage = [UIImage imageNamed:@"title2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDesc3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"title3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDesc3;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleImage = [UIImage imageNamed:@"title4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
    [intro setDelegate:self];
    [intro setPages:@[page1,page2,page3,page4]];
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)showCustomIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.titlePositionY = 240;
    page1.desc = sampleDesc1;
    page1.descPositionY = 220;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    page1.imgPositionY = 100;
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 240;
    page2.desc = sampleDesc2;
    page2.descPositionY = 220;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleImage = [UIImage imageNamed:@"icon1"];
    page2.imgPositionY = 260;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titlePositionY = 240;
    page3.desc = sampleDesc3;
    page3.descPositionY = 220;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"icon2"];
    page3.imgPositionY = 260;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.titlePositionY = 240;
    page4.desc = sampleDesc3;
    page4.descPositionY = 220;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleImage = [UIImage imageNamed:@"icon3"];
    page4.imgPositionY = 260;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    intro.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigLogo"]];
    intro.titleViewY = 120;
    
    [intro setDelegate:self];
    
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageDot"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"selectedPageDot"];
    [pageControl sizeToFit];
    [self.view addSubview:pageControl];
    intro.pageControl = (UIPageControl *)pageControl;
    [intro addSubview:intro.pageControl];
    intro.pageControlY = 130.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((320-270)/2, [UIScreen mainScreen].bounds.size.height - 80, 270, 50)];
    intro.skipButton = btn;
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // all settings are basic, pages with custom packgrounds, title image on each page
        [self showIntroWithCrossDissolve];
    } else if (indexPath.row == 1) {
        // all settings are basic, introview with colored background, fixed title image
        [self showIntroWithFixedTitleView];
    } else if (indexPath.row == 2) {
        // basic pages with custom settings
        [self showIntroWithCustomPages];
    } else if (indexPath.row == 3) {
        // using page with custom view
        [self showIntroWithCustomView];
    } else if (indexPath.row == 4) {
        // using page with custom view from nib
        [self showIntroWithCustomViewFromNib];
    } else if (indexPath.row == 5) {
        // pages separate init and using own subclass as one of pages
        [self showIntroWithSeparatePagesInitAndPageSubclass];
    } else if (indexPath.row == 6) {
        // show custom intro
        [self showCustomIntro];
    }
}

@end
