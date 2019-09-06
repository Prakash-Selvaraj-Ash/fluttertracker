// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leg_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegResponse _$LegResponseFromJson(Map<String, dynamic> json) {
  return LegResponse(
    distance: json['distance'] == null
        ? null
        : DistanceResponse.fromJson(json['distance'] as Map<String, dynamic>),
    duration: json['duration'] == null
        ? null
        : DurationResponse.fromJson(json['duration'] as Map<String, dynamic>),
    startLocation: json['start_location'] == null
        ? null
        : LocationResponse.fromJson(
            json['start_location'] as Map<String, dynamic>),
    endLocation: json['end_location'] == null
        ? null
        : LocationResponse.fromJson(
            json['end_location'] as Map<String, dynamic>),
    steps: (json['steps'] as List)
        ?.map((e) =>
            e == null ? null : StepResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LegResponseToJson(LegResponse instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'start_location': instance.startLocation,
      'end_location': instance.endLocation,
      'steps': instance.steps,
    };
