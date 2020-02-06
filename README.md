# flutter_instagram_stories

[![pub package](https://img.shields.io/pub/v/camera.svg)](https://pub.dartlang.org/packages/camera)

A Flutter plugin for displaying stories just like Whatsapp & Instagram. Built-in groups (multiple stories with one icon), cache, video, gifs.

Plugin can be used in any app for displaying news, educational content and etc.


*Note*: This plugin is under ative development, and there are some known bugs and a lot of features to implement. Add issues or feature requests here: [issue](https://github.com/awaik/flutter_instagram_stories/issues)



![Showcase|100x100, 10%](example/lib/showcase1.gif)

Important notes:

1. For now plugin works with Firebase only.
2. This is first beta version, please


# Features

* Only one line of code to implement this plugin to app
* Display images, gifs, videos
* Adjustable titles on icons
* Preliminary caching after app started

## Installing

```yaml
dependencies:
  flutter_instagram_stories: ^0.1.0
```

Now in your Dart code, you can use:

```dart
import 'import 'package:flutter_instagram_stories/flutter_instagram_stories.dart';';
```

## iOS

For playing video uses official video_player plugin https://pub.dev/packages/video_player

From documentation:

1.  Warning: The video_player plugin doesn’t work on iOS simulators. You must test videos on real iOS devices.

2. For iOS, add the following to the Info.plist file found at <project root>/ios/Runner/Info.plist.

	<key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>

## Usage

```dart
  VerificationCode(
      keyboardType: TextInputType.number,
      length: 4,
      autofocus: true,
      onCompleted: (String value) {
        //...
        print(value);
      },
  )
```

```dart
onEditing: (bool value) {
  setState(() {
    _onEditing = value;
  });
},
```

```dart
Center(
              child: (_onEditing != true)
                  ? Text('Your code: $_code')
                  : Text('Please enter full code'),
            ),
```