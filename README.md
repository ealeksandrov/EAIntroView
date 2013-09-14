#EAIntroView - simple iOS Introductions

![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/1.png)
![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/2.png)

This is highly customizable drop-in solution for introduction views.
Some features (all features are optional):

* swipe from last page to close
* custom background for each page with cross-dissolve transition
* for each page - background, title image, title text, description and their separate Y positions
* custom background or color for whole view
* custom page control, skip button

This control is inspired by [MYIntroductionView](https://github.com/MatthewYork/iPhone-IntroductionTutorial) by [Matthew York](https://github.com/MatthewYork). Take it if you want right-to-left language support or autorotation and resize.

License: MIT.

##CocoaPods
Will add CocoaPods instructions as soon as control is approved in official repo.

##Manual installation

* add `EAIntroPage` and `EAIntroView` headers and implementations to your project (4 files total)
* `#import "EAIntroView.h"` to use it in a class
* Subscribe to the `EAIntroDelegate` to enable delegate/callback interaction.

##How To Use It

Sample project have some examples of customization. Look in `viewDidAppear`, uncomment some lines to see variants.

###Step 1 - Build Pages
Each page created with `[EAIntroPage page]` class method. Then you can customize any property, all of them are optional.

Simple

```objc
EAIntroPage *page1 = [EAIntroPage page];
page1.title = @"Hello world";
page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
```

Custom

```objc
EAIntroPage *page3 = [EAIntroPage page];
page3.title = @"This is page 3";
page3.titlePositionY = 220;
page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
page3.descPositionY = 200;
page3.bgImage = [UIImage imageNamed:@"3"];
page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
page3.imgPositionY = 100;
```    

###Step 2 - Create Introduction View
Once all pages have been created,  you are ready to create the introduction view. Just pass them in right order in the introduction view.

Simple

```objc
EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
```

Custom

```objc
EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
intro.backgroundColor = [UIColor colorWithRed:1.0f green:0.58f blue:0.21f alpha:1.0f]; //iOS7 orange    
intro.pageControlY = 80.0f;    
UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
[btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 70, 230, 40)];
[btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
[btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
intro.skipButton = btn;
```

Don't forget to set the delegate to the calling class if you are using delegation for any callbacks

```objc
[intro setDelegate:self];
```

###Step 3 - Show Introduction View

```objc
[intro showInView:self.view animateDuration:0.0];
```