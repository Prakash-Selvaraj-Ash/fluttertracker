// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_track_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveTrackResponseDto _$LiveTrackResponseDtoFromJson(Map<String, dynamic> json) {
  return LiveTrackResponseDto(
    lastDestination: json['LastDestination'] == null
        ? null
        : PlaceResponse.fromJson(
            json['LastDestination'] as Map<String, dynamic>),
    currentLocationCoordinate: json['CurrentLocationCoordinate'] == null
        ? null
        : GeoCoordinateDto.fromJson(
            json['CurrentLocationCoordinate'] as Map<String, dynamic>),
    places: (json['Places'] as List)
        ?.map((e) => e == null
            ? null
            : PlaceWithEtaResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LiveTrackResponseDtoToJson(
        LiveTrackResponseDto instance) =>
    <String, dynamic>{
      'LastDestination': instance.lastDestination,
      'CurrentLocationCoordinate': instance.currentLocationCoordinate,
      'Places': instance.places,
    };
