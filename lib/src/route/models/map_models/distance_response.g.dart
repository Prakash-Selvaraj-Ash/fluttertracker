// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistanceResponse _$DistanceResponseFromJson(Map<String, dynamic> json) {
  return DistanceResponse(
    text: json['text'] as String,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$DistanceResponseToJson(DistanceResponse instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
