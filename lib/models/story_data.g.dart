// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryData _$StoryDataFromJson(Map<String, dynamic> json) {
  return StoryData(
    filetype: json['filetype'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$StoryDataToJson(StoryData instance) => <String, dynamic>{
      'filetype': instance.filetype,
      'url': instance.url,
    };
