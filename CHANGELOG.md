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
