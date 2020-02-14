// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryData _$StoryDataFromJson(Map<String, dynamic> json) {
  return StoryData(
    filetype: json['filetype'] as String,
    url: (json['url'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  )..fileTitle = (json['fileTitle'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$StoryDataToJson(StoryData instance) => <String, dynamic>{
      'filetype': instance.filetype,
      'url': instance.url,
      'fileTitle': instance.fileTitle,
    };
