#EARestrictedScrollView

[![CI Status](http://img.shields.io/travis/ealeksandrov/EARestrictedScrollView.svg?style=flat)](https://travis-ci.org/ealeksandrov/EARestrictedScrollView)
[![Version](https://img.shields.io/cocoapods/v/EARestrictedScrollView.svg?style=flat)](http://cocoadocs.org/docsets/EARestrictedScrollView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/EARestrictedScrollView.svg?style=flat)](http://cocoadocs.org/docsets/EARestrictedScrollView)
[![Platform](https://img.shields.io/cocoapods/p/EARestrictedScrollView.svg?style=flat)](http://cocoadocs.org/docsets/EARestrictedScrollView)

![DemoGIF](https://raw.githubusercontent.com/ealeksandrov/EARestrictedScrollView/master/Demo.gif)

**`UIScrollView` sublass with ability to restrict scrolling area.**

In plain `UIScrollView` only `contentSize` can be changed, but not the origin of scrolling area. This simple and universal solution allows to restrict scrolling area with `CGRect`.

## Installation

You can setup EARestrictedScrollView using [Carthage](https://github.com/Carthage/Carthage), [CocoaPods](http://github.com/CocoaPods/CocoaPods) or [completely manually](#setting-up-manually).

### Carthage

1. Add EARestrictedScrollView to your project's `Cartfile`:

	```ruby
	github "ealeksandrov/EARestrictedScrollView"
	```

2. Run `carthage update` in your project directory.
3. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop **EARestrictedScrollView.framework** from the `Carthage/Build/iOS/` folder on disk.
4. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

	```shell
	/usr/local/bin/carthage copy-frameworks
	```
	
	and add the path to the framework under “Input Files”:
	
	```shell
	$(SRCROOT)/Carthage/Build/iOS/EARestrictedScrollView.framework
	```

### CocoaPods

1. Add EARestrictedScrollView to your project's `Podfile`:

	```ruby
	pod 'EARestrictedScrollView', '~> 1.1.0'
	```

2. Run `pod update` or `pod install` in your project directory.

### Setting Up Manually

1. Clone EARestrictedScrollView from Github.
2. Copy and add `EARestrictedScrollView` header and implementation to your project.
3. You can now use EARestrictedScrollView by adding the following import:

	```objective-c
	@import EARestrictedScrollView; // If you're using EARestrictedScrollView.framework

	// OR

	#import "EARestrictedScrollView.h"
	```

##How To Use It

Can be created from code as usual:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    EARestrictedScrollView *restrictedScrollView = [[EARestrictedScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:restrictedScrollView];
    
    UIImage *bgImage = [UIImage imageNamed:@"milky-way.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
    [restrictedScrollView addSubview:imageView];
    [restrictedScrollView setContentSize:imageView.frame.size];
}
```

Or from Interface Builder:

![IB screenshot](https://raw.githubusercontent.com/ealeksandrov/EARestrictedScrollView/master/ScreenshotIB.png)

Update scrolling area with new `restrictionArea` property. Reset restriction with passing `CGRectZero` to `restrictionArea`.

```
- (void)changeSwitch:(id)sender {
    UISwitch *areaSwitch = (UISwitch *)sender;
    
    if([areaSwitch isOn]){
        [restrictedScrollView setRestrictionArea:areaSwitch.superview.frame];
    } else {
        [restrictedScrollView setRestrictionArea:CGRectZero];
    }
}
```

To access subviews use `containedSubviews` property. It was added in version 0.2.0 since `subviews` override caused some [troubles with autolayout](https://github.com/ealeksandrov/EAIntroView/issues/100).

```objective-c
NSArray *subviews = restrictedScrollView.containedSubviews;
```

##Author

Created and maintained by Evgeny Aleksandrov ([@EAleksandrov](https://twitter.com/EAleksandrov)).

## License

`EARestrictedScrollView` is available under the MIT license. See the LICENSE file for more info.
