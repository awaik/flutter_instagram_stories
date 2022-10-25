## 1.0.3

* Deleted predefined background color https://github.com/awaik/flutter_instagram_stories/issues/18

## 1.0.2+1

* Updated dependencies

## 1.0.2

* Fixed bug wil null error (issue: 14)
* Updated dependencies

## 1.0.1+1

* Updated dependencies
* Recreated example - now it is runnable again

## 1.0.0

* Flutter 2.0.0 & null safety

## 0.1.5+7

* Updated dependencies

## 0.1.5+6

* Updated dependencies

## 0.1.5+5

* Fixed documentation issue


## 0.1.5+4

* Change documentation

## 0.1.5+3

* Change deprecated document() to doc() in Firestore request


## 0.1.5+2

* Fixed bug with snapshot data
* Removed unnecessary packages.
* Fixed bug with flutter_cache_manager: ^2.0.0, by downgrading package.

## 0.1.5+1

* Upgrade packages

## 0.1.5

* Update code for `cloud_firestore: ^0.14.0` and for `Flutter (Channel stable, 1.20.2`

Important!  cloud_firestore: ^0.14.0 have changed some methods, that could require to rewrite some code in your app.

## 0.1.4+2

* Add image with database structure.

## 0.1.4+1

* Add to readme info about new options.

## 0.1.4

* Add caption support to each slide. Now it is possible to add to Firestore database the map for each slide
```
fileTitle: {en: "Caption on the video"}
```
multi language supported by adding maps with different locales.


* Add options for styling captions on images & videos
```
    captionTextStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
    captionMargin: EdgeInsets.only(
      bottom: 50,
    ),
    captionPadding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 8,
    ),
```

## 0.1.3+5

* Changed aspect ratio for single story image - it solves issue with iphone 11 displaying.

## 0.1.3+4

* Fixed minor issue https://github.com/awaik/flutter_instagram_stories/issues/7
* Fixed background color between pages

## 0.1.3+3

* Update dependencies and read.me

## 0.1.3+2

* Fix some minor bugs.


## 0.1.3+1

* Move close button a little bit.

## 0.1.3

* Add option `bool sortingOrderDesc;`
* Add options for highlighting last stories
```
    lastIconHighlight: true,
    lastIconHighlightColor: Colors.deepOrange,
    lastIconHighlightRadius: const Radius.circular(15.0),
```

## 0.1.2

* Add VoidCallback `backFromStories`. This create event when user closed stories screen. Find details in the [example](https://github.com/awaik/flutter_instagram_stories/blob/master/example/lib/main.dart).
* Add option for styling close button. Find details in the [example](https://github.com/awaik/flutter_instagram_stories/blob/master/example/lib/main.dart).
```
    /// stories close button style
    Icon closeButtonIcon;
    Color closeButtonBackgroundColor;
```
* Add option for background color during stories listing `backgroundColorBetweenStories: Colors.black,`

## 0.1.1

* BREAKING CHANGE. Add multilanguage support for images inside story, database structure have changed

## 0.1.0+3

* Add option `textInIconPadding`
* Improved preview skeleton during loading

## 0.1.0+2

* Fixed bug with stories listing.
* Improved README.MD

## 0.1.0+1

* Fixed bug with stories opening.
* Improved README.MD

## 0.1.0

* BREAKING CHANGE.
  1. Added multilanguage support for preview images title.
  2. For future changes, added multilanguage fields to stories.
* Add option `iconImageBorderRadius` - set roundness of the preview images
* Add option `iconBoxDecoration` - set style of the preview images
* Change example
* Change documentation


## 0.0.1+1

* Fixed bug when Stories placed inside column
* Improved example


## 0.0.1

* Initial Release
