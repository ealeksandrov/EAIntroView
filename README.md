#EAIntroView - simple iOS Introductions

![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/1.png)
![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/2.png)

This is highly customizable drop-in solution for introduction views.
Some features (all features are optional):

* swipe from last page to close
* custom background for each page with cross-dissolve transition
* for each page - background, title image, title text, description and their separate Y positions
* possibility to set your own custom view for page
* custom background or color for whole view
* custom page control, skip button
* storyboard/IB support
* autoresize support

This control is inspired by [MYIntroductionView](https://github.com/MatthewYork/iPhone-IntroductionTutorial) by [Matthew York](https://github.com/MatthewYork).

License: MIT.

##CocoaPods

[CocoaPods](http://cocoapods.org/) is the recommended way to use EAIntroView in your project. 

* Simply add this line to your `Podfile`: `pod 'EAIntroView', '~> 1.3.0'`
* Run `pod install`.
* Include with `#import "EAIntroView.h"` to use it wherever you need.
* Subscribe to the `EAIntroDelegate` to enable delegate/callback interaction.

##Manual installation

* Add `EAIntroPage` and `EAIntroView` headers and implementations to your project (4 files total).
* Include with `#import "EAIntroView.h"` to use it wherever you need.
* Subscribe to the `EAIntroDelegate` to enable delegate/callback interaction.

##How To Use It

Sample project have some examples of customization. Look in `viewDidAppear`, uncomment some lines to see variants.

###Step 1 - Build Pages
Each page created with `[EAIntroPage page]` class method. Then you can customize any property, all of them are optional. Another approach is to pass your own, custom view in `EAIntroPage`, this way every other option is ignored.

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
page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
page3.titlePositionY = 220;
page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.";
page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
page3.descPositionY = 200;
page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
page3.imgPositionY = 100;
```

Custom view

```objc
UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 300, 30)];
labelForPage2.text = @"Some custom view";
labelForPage2.font = [UIFont systemFontOfSize:32];
labelForPage2.textColor = [UIColor whiteColor];
labelForPage2.backgroundColor = [UIColor clearColor];
labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
[viewForPage2 addSubview:labelForPage2];
EAIntroPage *page2 = [EAIntroPage pageWithCustomView:viewForPage2];
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
intro.pageControlY = 100.0f;    
UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
[btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
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

###Storyboard/IB
Since 1.3.0 EAIntroView supports init from IB.

1. Drop UIView to your IB document.
2. Set its class to `EAIntroView`.
3. Create `IBOutlet` property in your view controller: `@property(nonatomic,weak) IBOutlet EAIntroView *introView;`.
4. Connect `IBOutlet` with `EAIntroView` in IB.
5. Build array of pages and pass it to `EAIntroView` property in `setPages:`.