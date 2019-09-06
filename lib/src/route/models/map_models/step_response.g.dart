// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepResponse _$StepResponseFromJson(Map<String, dynamic> json) {
  return StepResponse(
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
    polyline: json['polyline'] == null
        ? null
        : PolyLineResponse.fromJson(json['polyline'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StepResponseToJson(StepResponse instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'start_location': instance.startLocation,
      'end_location': instance.endLocation,
      'polyline': instance.polyline,
    };
