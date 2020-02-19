import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'models/stories.dart';
import 'settings.dart';
import 'models/stories_list_with_pressed.dart';
import 'components//stories_list_skeleton.dart';
import 'models/stories_data.dart';
import 'grouped_stories_view.dart';

export 'grouped_stories_view.dart';

class FlutterInstagramStories extends StatefulWidget {
  /// the name of collection in Firestore, more info here https://github.com/awaik/flutter_instagram_stories
  String collectionDbName;
  String languageCode;

  /// preview images settings
  double iconWidth;
  double iconHeight;
  bool showTitleOnIcon = true;
  TextStyle iconTextStyle;
  BoxDecoration iconBoxDecoration;
  BorderRadius iconImageBorderRadius;
  EdgeInsets textInIconPadding;

  /// how long story lasts
  int imageStoryDuration;

  /// stories close button style
  Icon closeButtonIcon;
  Color closeButtonBackgroundColor;

  /// callback to get data that stories screen was opened
  VoidCallback backFromStories;

  ProgressPosition progressPosition;
  bool repeat;
  bool inline;

  FlutterInstagramStories(
      {@required this.collectionDbName,
      this.iconWidth,
      this.iconHeight,
      this.showTitleOnIcon,
      this.iconTextStyle,
      this.iconBoxDecoration,
      this.iconImageBorderRadius,
      this.textInIconPadding =
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      this.imageStoryDuration,
      this.closeButtonIcon,
      this.closeButtonBackgroundColor,
      this.backFromStories,
      this.progressPosition = ProgressPosition.top,
      this.repeat = true,
      this.inline = false,
      this.languageCode = 'en'});

  @override
  _FlutterInstagramStoriesState createState() =>
      _FlutterInstagramStoriesState();
}

class _FlutterInstagramStoriesState extends State<FlutterInstagramStories> {
  StoriesData _storiesData;
  final _firestore = Firestore.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _storiesData = StoriesData(languageCode: widget.languageCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: widget.iconHeight + 24,
      child: StreamBuilder(
        stream: _firestore.collection(widget.collectionDbName).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              primary: false,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                  child: InkWell(
                    child: Container(
                      width: widget.iconWidth,
                      height: widget.iconHeight,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: widget.iconImageBorderRadius,
                            child: StoriesListSkeletonAlone(
                              width: widget.iconWidth,
                              height: widget.iconHeight,
                            ),
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

          final List<Stories> storyWidgets =
              _storiesData.parseStoriesPreview(stories);

          // the variable below is for passing stories ids to screen Stories
          final List<String> storiesIdsList = _storiesData.storiesIdsList;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: storyWidgets == null ? 0 : stories.length,
            itemBuilder: (BuildContext context, int index) {
              Stories story = storyWidgets[index];
              story.previewTitle.putIfAbsent(widget.languageCode, () => '');

              return Padding(
                padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                child: InkWell(
                  child: Container(
                    decoration: widget.iconBoxDecoration,
                    width: widget.iconWidth,
                    height: widget.iconHeight,
                    child: Stack(children: <Widget>[
                      ClipRRect(
                        borderRadius: widget.iconImageBorderRadius,
                        child: CachedNetworkImage(
                          imageUrl: story.previewImage,
                          width: widget.iconWidth,
                          height: widget.iconHeight,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              StoriesListSkeletonAlone(
                            width: widget.iconWidth,
                            height: widget.iconHeight,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Container(
                        width: widget.iconWidth,
                        height: widget.iconHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: widget.textInIconPadding,
                              child: Text(
                                story.previewTitle[widget.languageCode],
                                style: widget.iconTextStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupedStoriesView(
                          collectionDbName: widget.collectionDbName,
                          languageCode: widget.languageCode,
                          imageStoryDuration: widget.imageStoryDuration,
                          progressPosition: widget.progressPosition,
                          repeat: widget.repeat,
                          inline: widget.inline,
                          closeButtonIcon: widget.closeButtonIcon,
                          closeButtonBackgroudColor:
                              widget.closeButtonBackgroundColor,
                        ),
                        settings: RouteSettings(
                          arguments: StoriesListWithPressed(
                              pressedStoryId: story.storyId,
                              storiesIdsList: storiesIdsList),
                        ),
                      ),
                    );
                    if (result == 'back_from_stories_view') {
                      widget.backFromStories();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
