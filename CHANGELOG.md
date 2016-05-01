# EAIntroView

## Upcoming

* Adds text alignment to title and description labels
* Replaces delegate call `introDidFinish:` with `introDidFinish:wasSkipped:` to include flag if intro was skipped

## Version 2.8.3

* Fixes scrolling restriction
* Replaces `limitScrollingToPage:` method with `limitPageIndex` property

## Version 2.8.2

* Adds exposed `[EAIntroView pageWithCustomViewFromNibNamed:bundle:]` to allow choosing a bundle
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
* Fixes `currentPage` property on `setPages:`
* Fixes `setCurrentPageIndex:` called with `animated:NO` - updates ivar directly
* Updates pod deployment target to iOS 6

## Version 2.7.4

* Fixes autolayout for custom views
* Updates `EARestrictedScrollView` dependency to fix autolayout crash
* Updates custom view bg color to use page bg color

## Version 2.7.3

* Adds skip button height constraint
* Adds autolayout on pages from Xib
* Adds fullscreen presentation
* Removes autolayout conditional checks and resizing masks
* Fixes page control hiding
* Fixes skip button hiding
* Fixes resizing

## Version 2.7.0
