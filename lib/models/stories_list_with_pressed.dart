class StoriesListWithPressed {
  String? pressedStoryId;
  List<String>? storiesIdsList;

  String? nextElementStoryId() {
    int position =
        storiesIdsList!.indexWhere((id) => id.startsWith(pressedStoryId!));
    if (storiesIdsList!.length == position + 1 || position == -1) {
      return null;
    }
    position++;
    return storiesIdsList![position];
  }

  String? previousElementStoryId() {
    int position =
        storiesIdsList!.indexWhere((id) => id.startsWith(pressedStoryId!));
    if (position - 1 < 0) {
      return null;
    }
    position--;
    return storiesIdsList![position];
  }

  StoriesListWithPressed({this.pressedStoryId, this.storiesIdsList});
}
