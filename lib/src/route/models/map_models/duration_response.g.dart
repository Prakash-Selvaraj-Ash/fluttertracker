// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DurationResponse _$DurationResponseFromJson(Map<String, dynamic> json) {
  return DurationResponse(
    text: json['text'] as String,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$DurationResponseToJson(DurationResponse instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
