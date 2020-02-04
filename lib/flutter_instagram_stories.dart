import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'models/stories.dart';
import 'models/stories_list_with_pressed.dart';
import 'components//stories_list_skeleton.dart';
import 'models/stories_data.dart';
import 'grouped_stories_view.dart';

class StoriesIconsBuilder extends StatefulWidget {
  Stream<QuerySnapshot> storiesStream;
  String collectionDbName;

  StoriesIconsBuilder({this.storiesStream, this.collectionDbName});

  @override
  _StoriesIconsBuilderState createState() => _StoriesIconsBuilderState();
}

class _StoriesIconsBuilderState extends State<StoriesIconsBuilder> {
  final _storiesData = StoriesData();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.storiesStream,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            story.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
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
