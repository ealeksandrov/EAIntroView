# EAIntroView

## Upcoming



## Version 2.12.0

* Adds Carthage compatibility ([#204](https://github.com/ealeksandrov/EAIntroView/issues/204))
* Removes `setCurrentPageIndex:` and `setCurrentPageIndex:animated:` (see discussion in [#213](https://github.com/ealeksandrov/EAIntroView/issues/213))
* Fixes `scrollToPageForIndex:animated:` not triggering lifecycle actions for `animated:NO` ([#213](https://github.com/ealeksandrov/EAIntroView/issues/213))
* Fixes unintended behavior for `pageControl` action while manually swiping pages ([#201](https://github.com/ealeksandrov/EAIntroView/issues/201))

## Version 2.11.0

* Adds obj-c lightweight generics
* Adds autolayout constraints to keep titleIconView inside page frame ([#212](https://github.com/ealeksandrov/EAIntroView/issues/212))

## Version 2.10.0

* Adds "Tap to next" support on custom views
* Adds delegate method `introWillFinish:wasSkipped:`
* Adds delegate method `intro:didScrollWithOffset:`
* Fixes crash when removing EAIntroView from the view hierarchy ([#168](https://github.com/ealeksandrov/EAIntroView/issues/168))
* Fixes bug when tapping a page to advance does not call the delegate method `pageAppeared` ([#174](https://github.com/ealeksandrov/EAIntroView/issues/174))
* Fixes constraints for `skipButton` and `pageControl` ([#185](https://github.com/ealeksandrov/EAIntroView/issues/185))
* Fixes layout issue on rotation for iPad ([#149](https://github.com/ealeksandrov/EAIntroView/issues/149))

## Version 2.9.0

* Adds Cocoapods 1.0.0 support for example project
* Adds text alignment to title and description labels
* Updates accessibility (better VoiceOver support)
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
