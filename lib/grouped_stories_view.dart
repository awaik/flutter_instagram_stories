import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'story_video.dart';
import 'story_image.dart';
import 'story_controller.dart';
import 'story_view.dart';
import 'models/stories_list_with_pressed.dart';

export 'story_image.dart';
export 'story_video.dart';
export 'story_controller.dart';
export 'story_view.dart';

import 'models/stories_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupedStoriesView extends StatefulWidget {
  String collectionDbName;

  GroupedStoriesView({this.collectionDbName});

  @override
  _GroupedStoriesViewState createState() => _GroupedStoriesViewState();
}

class _GroupedStoriesViewState extends State<GroupedStoriesView> {
  final _firestore = Firestore.instance;
  final storyController = StoryController();
  List<List<StoryItem>> storyItemList = [];
  StoriesData _storiesData = StoriesData();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StoriesListWithPressed storiesListWithPressed =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: StreamBuilder(
        stream: _firestore
            .collection(widget.collectionDbName)
            .document(storiesListWithPressed.pressedStoryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          Map<String, dynamic> toPass = {
            'snapshotData': snapshot.data,
            'pressedStoryId': storiesListWithPressed.pressedStoryId
          };
          _storiesData.parseStories(toPass);
          storyItemList.add(_storiesData.storyItems);

          return Dismissible(
              resizeDuration: Duration(milliseconds: 200),
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  String nextStoryId =
                      storiesListWithPressed.nextElementStoryId();
                  if (nextStoryId == null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupedStoriesView(
                          collectionDbName: widget.collectionDbName,
                        ),
                        settings: RouteSettings(
                          arguments: StoriesListWithPressed(
                              pressedStoryId: nextStoryId,
                              storiesIdsList:
                                  storiesListWithPressed.storiesIdsList),
                        ),
                      ),
                    );
                  }
                } else {
                  String previousStoryId =
                      storiesListWithPressed.previousElementStoryId();
                  if (previousStoryId == null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupedStoriesView(
                          collectionDbName: widget.collectionDbName,
                        ),
                        settings: RouteSettings(
                          arguments: StoriesListWithPressed(
                              pressedStoryId: previousStoryId,
                              storiesIdsList:
                                  storiesListWithPressed.storiesIdsList),
                        ),
                      ),
                    );
                  }
                }
              },
              child: GestureDetector(
                child: StoryView(
                  storyItemList[0],
                  controller: storyController,
                  onStoryShow: (StoryItem s) {
                    _onStoryShow(s);
                  },
                  onComplete: () {
                    String nextStoryId =
                        storiesListWithPressed.nextElementStoryId();
                    if (nextStoryId == null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupedStoriesView(
                            collectionDbName: widget.collectionDbName,
                          ),
                          settings: RouteSettings(
                            arguments: StoriesListWithPressed(
                              pressedStoryId: nextStoryId,
                              storiesIdsList:
                                  storiesListWithPressed.storiesIdsList,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    Navigator.pop(context);
                  }
                },
              ));
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment(1.1, -0.85),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.blueGrey,
            size: 28.0,
          ),
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
        ),
      ),
    );
  }

  void _onStoryShow(StoryItem s) {}
}
