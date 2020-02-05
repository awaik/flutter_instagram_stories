import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'models/stories.dart';
import 'models/stories_list_with_pressed.dart';
import 'components//stories_list_skeleton.dart';
import 'models/stories_data.dart';
import 'grouped_stories_view.dart';

class FlutterInstagramStories extends StatefulWidget {
  String collectionDbName;
  bool showTitleOnIcon = true;
  bool showTitleInStory = true;
  Duration duration = const Duration(seconds: 3);
  double fontSizeIcon = 16;
  double fontSizeStory = 24;

  FlutterInstagramStories(
      {@required this.collectionDbName,
      this.showTitleOnIcon,
      this.showTitleInStory,
      this.duration,
      this.fontSizeIcon,
      this.fontSizeStory});

  @override
  _FlutterInstagramStoriesState createState() =>
      _FlutterInstagramStoriesState();
}

class _FlutterInstagramStoriesState extends State<FlutterInstagramStories> {
  final _storiesData = StoriesData();
  final _firestore = Firestore.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection(widget.collectionDbName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 20),
                child: InkWell(
                  child: Container(
                    height: 178,
                    width: 140,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: StoriesListSkeletonAlone(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        final stories = snapshot.data.documents;
        _storiesData.parseStoriesPreview(stories);
        List<Stories> storyWidgets = _storiesData.storyWidgets;
        // the variable below is for passing stories ids to screen Stories
        List<String> storiesIdsList = _storiesData.storiesIdsList;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          primary: false,
          itemCount: storyWidgets == null ? 0 : stories.length,
          itemBuilder: (BuildContext context, int index) {
            Stories story = storyWidgets[index];
            print(
                '++++++++++++++++++++++++++++++++++++++++++++++++++11 ${story.title}');

            return Padding(
              padding: EdgeInsets.only(left: 20),
              child: InkWell(
                child: Container(
                  height: 178,
                  width: 140,
                  child: Stack(children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: story.previewImage,
                        height: 178,
                        width: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            StoriesListSkeletonAlone(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Container(
                      height: 178,
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 130.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              story.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSizeIcon,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupedStoriesView(
                        collectionDbName: widget.collectionDbName,
                      ),
                      settings: RouteSettings(
                        arguments: StoriesListWithPressed(
                            pressedStoryId: story.storyId,
                            storiesIdsList: storiesIdsList),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
