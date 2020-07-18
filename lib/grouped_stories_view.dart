import 'dart:ui';

import 'package:flutter/material.dart';
import 'story_controller.dart';
import 'story_view.dart';
import 'models/stories_list_with_pressed.dart';
import 'settings.dart';

export 'story_image.dart';
export 'story_video.dart';
export 'story_controller.dart';
export 'story_view.dart';
export 'settings.dart';

import 'models/stories_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupedStoriesView extends StatefulWidget {
  final String collectionDbName;
  final String languageCode;
  final int imageStoryDuration;
  final ProgressPosition progressPosition;
  final bool repeat;
  final bool inline;
  final Icon closeButtonIcon;
  final Color closeButtonBackgroundColor;
  final Color backgroundColorBetweenStories;
  final bool sortingOrderDesc;
  TextStyle captionTextStyle;
  EdgeInsets captionMargin;
  EdgeInsets captionPadding;

  GroupedStoriesView(
      {this.collectionDbName,
      this.languageCode,
      this.imageStoryDuration,
      this.progressPosition,
      this.repeat,
      this.inline,
      this.backgroundColorBetweenStories,
      this.closeButtonIcon,
      this.closeButtonBackgroundColor,
      this.sortingOrderDesc,
      this.captionTextStyle,
      this.captionMargin,
      this.captionPadding});

  @override
  _GroupedStoriesViewState createState() => _GroupedStoriesViewState();
}

class _GroupedStoriesViewState extends State<GroupedStoriesView> {
  final _firestore = Firestore.instance;
  final storyController = StoryController();
  List<List<StoryItem>> storyItemList = [];
  StoriesData _storiesData;

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _storiesData = StoriesData(
      languageCode: widget.languageCode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StoriesListWithPressed storiesListWithPressed =
        ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () {
        _navigateBack();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: widget.backgroundColorBetweenStories,
//        backgroundColor: Colors.white,
        body: Container(
          color: Colors.black,
          child: StreamBuilder(
            stream: _firestore
                .collection(widget.collectionDbName)
                .document(storiesListWithPressed.pressedStoryId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[700],
                  ),
                );
              }
              Map<String, dynamic> toPass = {
                'snapshotData': snapshot.data,
                'pressedStoryId': storiesListWithPressed.pressedStoryId,
                'captionTextStyle': widget.captionTextStyle,
              };
              _storiesData.parseStories(
                toPass,
                widget.imageStoryDuration,
                widget.captionTextStyle,
                widget.captionMargin,
                widget.captionPadding,
              );
              storyItemList.add(_storiesData.storyItems);

              return Dismissible(
                  background:
                      Container(color: widget.backgroundColorBetweenStories),
                  crossAxisEndOffset: 0.0,
                  resizeDuration: Duration(milliseconds: 200),
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.endToStart) {
                      String nextStoryId =
                          storiesListWithPressed.nextElementStoryId();
                      if (nextStoryId == null) {
                        _navigateBack();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          NoAnimationMaterialPageRoute(
                            builder: (context) => _groupedStoriesView(),
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
                        _navigateBack();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          NoAnimationMaterialPageRoute(
                            builder: (context) => _groupedStoriesView(),
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
                      widget.sortingOrderDesc
                          ? storyItemList[0].reversed.toList()
                          : storyItemList[0],
                      controller: storyController,
                      progressPosition: widget.progressPosition,
                      repeat: widget.repeat,
                      inline: widget.inline,
                      onStoryShow: (StoryItem s) {
                        _onStoryShow(s);
                      },
                      goForward: () {},
                      onComplete: () {
                        String nextStoryId =
                            storiesListWithPressed.nextElementStoryId();
                        if (nextStoryId == null) {
                          _navigateBack();
                        } else {
                          Navigator.pushReplacement(
                            context,
                            NoAnimationMaterialPageRoute(
                              builder: (context) => _groupedStoriesView(),
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
                        _navigateBack();
                      }
                    },
                  ));
            },
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment(1.0, -0.84),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FloatingActionButton(
              onPressed: () {
                _navigateBack();
              },
              child: widget.closeButtonIcon,
              backgroundColor: widget.closeButtonBackgroundColor,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  GroupedStoriesView _groupedStoriesView() {
    return GroupedStoriesView(
      collectionDbName: widget.collectionDbName,
      languageCode: widget.languageCode,
      imageStoryDuration: widget.imageStoryDuration,
      captionTextStyle: widget.captionTextStyle,
      captionMargin: widget.captionMargin,
      captionPadding: widget.captionPadding,
      progressPosition: widget.progressPosition,
      repeat: widget.repeat,
      inline: widget.inline,
      backgroundColorBetweenStories: widget.backgroundColorBetweenStories,
      closeButtonIcon: widget.closeButtonIcon,
      closeButtonBackgroundColor: widget.closeButtonBackgroundColor,
      sortingOrderDesc: widget.sortingOrderDesc,
    );
  }

  _navigateBack() {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
      arguments: 'back_from_stories_view',
    );
  }

  void _onStoryShow(StoryItem s) {}
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
