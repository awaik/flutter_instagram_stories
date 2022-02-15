import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_instagram_stories/story_view.dart';

import 'stories.dart';

class StoriesData {
  String? languageCode;

  StoriesData({
    this.languageCode,
  });

  int _cacheDepth = 4;
  List<String> _storiesIdsList = [];

  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  List<String> get storiesIdsList => _storiesIdsList;

  List<Stories> parseStoriesPreview(var stories) {
    List<Stories> storyWidgets = [];
    for (final story in stories) {
      final Stories storyData = Stories.fromJson({
        'storyId': story.id,
        'date':
            DateTime.fromMillisecondsSinceEpoch(story.data()!['date'].seconds)
                .toIso8601String(),
        'file': jsonDecode(jsonEncode(story.data()!['file'])),
        'previewImage': story.data()!['previewImage'],
        'previewTitle': jsonDecode(jsonEncode(story.data()!['previewTitle'])),
      });
      if (storyData.file != null) {
        storyWidgets.add(storyData);
        _storiesIdsList.add(story.id);

//         preliminary caching
        var i = 0;
        for (var file in storyData.file!) {
          if (file.filetype == 'image' && i < _cacheDepth) {
            DefaultCacheManager().getSingleFile(file.url![languageCode!]!);
            i += 1;
          }
        }
      }
    }
    return storyWidgets;
  }

  void parseStories(
    Map<String, dynamic> toPass,
    imageStoryDuration,
    TextStyle? captionTextStyle,
    EdgeInsets? captionMargin,
    EdgeInsets? captionPadding,
  ) {
    Map<String, dynamic> temp = {
      'storyId': toPass['pressedStoryId'],
      'file': toPass['snapshotData']['file'],
      'title': toPass['snapshotData']['title'],
      'previewImage': toPass['snapshotData']['previewImage'],
    };
    Stories stories = Stories.fromJson(jsonDecode(jsonEncode(temp)));
    stories.file!.asMap().forEach((index, storyInsideImage) {
      if (storyInsideImage.filetype != 'video') {
        storyItems.add(StoryItem.pageImage(
          CachedNetworkImageProvider(storyInsideImage.url![languageCode!]!),
          // controller: storyController,
          duration: Duration(seconds: imageStoryDuration),
          caption: storyInsideImage.fileTitle != null
              ? storyInsideImage.fileTitle![languageCode!]
              : null,
          // captionTextStyle: captionTextStyle,
          // captionMargin: captionMargin,
          // captionPadding: captionPadding,
        ));

        ///todo fix
        // storyItems.add(StoryItem.pageGif(
        //   storyInsideImage.url![languageCode!],
        //   controller: storyController,
        //   duration: Duration(seconds: imageStoryDuration),
        //   caption: storyInsideImage.fileTitle != null
        //       ? storyInsideImage.fileTitle![languageCode!]
        //       : null,
        //   captionTextStyle: captionTextStyle,
        //   captionMargin: captionMargin,
        //   captionPadding: captionPadding,
        // ));
      } else {
        storyItems.add(
          StoryItem.pageVideo(
            storyInsideImage.url![languageCode!],
            controller: storyController,
            caption: storyInsideImage.fileTitle != null
                ? storyInsideImage.fileTitle![languageCode!]
                : null,
            captionTextStyle: captionTextStyle,
            captionPadding: captionPadding,
            captionMargin: captionMargin,
          ),
        );
      }
      // cache images inside story
      if (index < stories.file!.length - 1) {
        DefaultCacheManager()
            .getSingleFile(stories.file![index + 1].url![languageCode!]!);
      }
    });
  }
}
