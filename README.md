#EAIntroView - simple iOS Introductions

![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/1.png)
![BackgroundImage](https://raw.github.com/ealeksandrov/EAIntroView/master/2.png)

This is highly customizable drop-in solution for introduction views.
Some features (remember, most features are optional and can be turned off):

* beautiful demo project to look on some examples
	* customizability is unlimited, one can make complex introView with animations and interactive pages, so do not limit yourself with existing examples
* for each basic page: 
	* background (with cross-dissolve transition between pages)
	* title image (+ Y position)
	* title text (+ font, color and Y position)
	* description text (+ font, color and Y position)
	* subviews array (added to page after building default layout)
* possibility to set your own custom view for page:
	* pageWithCustomView:
	* pageWithCustomViewFromNibNamed:
* possibility to make sublass of EAIntroPage and react to actions:
	* pageDidLoad
	* pageDidAppear
	* pageDidDisappear
* many options to customize parent view:
	* swipe from last page to close
	* custom background image or color
	* custom page control
	* custom skip button
	* pinned titleView (+ Y position, can be hidden on some pages)
	* hide page control
* delegate protocol to listen:
	* introDidFinish:
	* intro:pageAppeared:withIndex:
* actions on IntroView:
	* setPages:
	* showInView:animateDuration:
	* hideWithFadeOutDuration:
	* setCurrentPageIndex:animated:
* storyboard/IB support
* autoresize support

License: MIT.

##CocoaPods

[CocoaPods](http://cocoapods.org/) is the recommended way to use EAIntroView in your project. 

* Simply add this line to your `Podfile`: `pod 'EAIntroView', '~> 2.0.0'`
* Run `pod install`.
* Include with `#import "EAIntroView.h"` to use it wherever you need.
* Subscribe to the `EAIntroDelegate` to enable delegate/callback interaction.

##Manual installation

* Add `EAIntroPage` and `EAIntroView` headers and implementations to your project (4 files total).
* Include with `#import "EAIntroView.h"` to use it wherever you need.
* Subscribe to the `EAIntroDelegate` to enable delegate/callback interaction.

##How To Use It

Sample project have many examples of customization. Here are only simple ones.

###Step 1 - Build Pages
Each page created with `[EAIntroPage page]` class method. Then you can customize any property, all of them are optional. Another approach is to pass your own (can be nib), custom view in `EAIntroPage`, this way most other options are ignored.

```objc
// basic
EAIntroPage *page1 = [EAIntroPage page];
page1.title = @"Hello world";
page1.desc = sampleDesc1;
// custom
EAIntroPage *page2 = [EAIntroPage page];
page2.title = @"This is page 2";
page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
page2.titlePositionY = 220;
page2.desc = sampleDesc2;
page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
page2.descPositionY = 200;
page2.titleImage = [UIImage imageNamed:@"title3"];
page2.imgPositionY = 100;
// custom view from nib
EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage"];
page3.bgImage = [UIImage imageNamed:@"bg2"];
```


###Step 2 - Create Introduction View
Once all pages have been created,  you are ready to create the introduction view. Just pass them in right order in the introduction view. You can also pass array of pages after IntroView's initialization, it will rebuild its contents.


```objc
EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
```

Don't forget to set the delegate if you want to use any callbacks.

```objc
[intro setDelegate:self];
```

###Step 3 - Show Introduction View

```objc
[intro showInView:self.view animateDuration:0.0];
```

###Storyboard/IB
Since 1.3.0 EAIntroView supports init from IB. Since 2.0.0 EAIntroPage supports it too.

1. Drop UIView to your IB document.
2. Set its class to `EAIntroView`.
3. Create `IBOutlet` property in your view controller: `@property(nonatomic,weak) IBOutlet EAIntroView *introView;`.
4. Connect `IBOutlet` with `EAIntroView` in IB.
5. Build array of pages (you can use `pageWithCustomViewFromNibNamed:` here with separate nibs for each page).
6. Pass pages array to `EAIntroView` property in `setPages:`.