import 'dart:convert';
import 'stories.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_instagram_stories/story_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoriesData {
  String languageCode;

  StoriesData({this.languageCode});

  int _cacheDepth = 4;
  List<String> _storiesIdsList = [];

  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  List<String> get storiesIdsList => _storiesIdsList;

  List<Stories> parseStoriesPreview(var stories) {
    List<Stories> storyWidgets = [];
    for (var story in stories) {
      final Stories storyData = Stories.fromJson({
        'storyId': story.documentID,
        'date': DateTime.fromMillisecondsSinceEpoch(story.data['date'].seconds)
            .toIso8601String(),
        'file': jsonDecode(jsonEncode(story.data['file'])),
        'previewImage': story.data['previewImage'],
        'previewTitle': jsonDecode(jsonEncode(story.data['previewTitle'])),
      });
      if (storyData.file != null) {
        storyWidgets.add(storyData);
        _storiesIdsList.add(story.documentID);

//         preliminary caching
        var i = 0;
        for (var file in storyData.file) {
          if (file.filetype == 'image' && i < _cacheDepth) {
            DefaultCacheManager().getSingleFile(file.url[languageCode]);
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
  ) {
    Map<String, dynamic> temp = {
      'storyId': toPass['pressedStoryId'],
      'file': toPass['snapshotData']['file'],
      'title': toPass['snapshotData']['title'],
      'previewImage': toPass['snapshotData']['previewImage'],
    };
    Stories stories = Stories.fromJson(jsonDecode(jsonEncode(temp)));

    stories.file.asMap().forEach((index, storyInsideImage) {
      if (storyInsideImage.filetype != 'video') {
        CachedNetworkImageProvider(storyInsideImage.url[languageCode]);
        storyItems.add(StoryItem.pageGif(
          storyInsideImage.url[languageCode],
          controller: storyController,
          duration: Duration(seconds: imageStoryDuration),
        ));
      } else {
        storyItems.add(
          StoryItem.pageVideo(
            storyInsideImage.url[languageCode],
            controller: storyController,
          ),
        );
      }
      // cache images inside story
      if (index < stories.file.length - 1) {
        DefaultCacheManager()
            .getSingleFile(stories.file[index + 1].url[languageCode]);
      }
    });
  }
}
