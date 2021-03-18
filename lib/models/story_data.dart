import 'package:json_annotation/json_annotation.dart';

part 'story_data.g.dart';

@JsonSerializable(explicitToJson: true)
class StoryData {
  String? filetype;
  Map<String, String>? url;
  Map<String, String>? fileTitle;

  StoryData({this.filetype, this.url});

  factory StoryData.fromJson(Map<String, dynamic> json) =>
      _$StoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$StoryDataToJson(this);
}
