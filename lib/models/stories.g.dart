// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stories _$StoriesFromJson(Map<String, dynamic> json) {
  return Stories(
    storyId: json['storyId'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    file: (json['file'] as List)
        ?.map((e) =>
            e == null ? null : StoryData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    previewImage: json['previewImage'] as String,
    previewTitle: (json['previewTitle'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'storyId': instance.storyId,
      'date': instance.date?.toIso8601String(),
      'file': instance.file?.map((e) => e?.toJson())?.toList(),
      'previewImage': instance.previewImage,
      'previewTitle': instance.previewTitle,
    };
