# EAIntroView

## Upcoming


## Version 2.8.2

* Adds Exposed [EAIntroView pageWithCustomViewFromNibNamed:bundle:] to allow choosing a bundle
* Fixes black background for pages with custom view

## Version 2.8.1

* Fixes import statement to support swift installation
* Adds description label side margins property

## Version 2.8.0

* Adds rotation support
* Adds autolayout to page elements
* Fixes constraints for custom skip button Y position
* Fixes import statement to support manual installation
* Fixes delegate method `introDidFinish:` fired too early
* Fixes `currentPage` property on `-setPages:`
* Fixes `-setCurrentPageIndex:` called with `animated:NO` - updates ivar directly
* Updates pod deployment target to iOS 6

## Version 2.7.4

* Fixes autolayout for custom views
* Updates `EARestrictedScrollView` dependency to fix autolayout crash
* Updates custom view bg color to use page bg color

## Version 2.7.3

* Adds skipButton height constraint
* Adds Autolayout on pages from Xib
* Adds fullscreen presentation
* Removes autolayout conditional checks and resizing masks
* Fixes PageControl hiding
* Fixes Skip button hiding
* Fixes resizing

## Version 2.7.0
