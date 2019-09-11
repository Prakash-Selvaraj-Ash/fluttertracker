// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_track_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusTrackResponseDto _$BusTrackResponseDtoFromJson(Map<String, dynamic> json) {
  return BusTrackResponseDto(
    id: json['Id'] as String,
    busId: json['BusId'] as String,
    lastDestination: json['LastDestination'] == null
        ? null
        : PlaceResponse.fromJson(
            json['LastDestination'] as Map<String, dynamic>),
    routeResponse: json['Route'] == null
        ? null
        : RouteResponse.fromJson(json['Route'] as Map<String, dynamic>),
    startLattitude: (json['StartLattitude'] as num)?.toDouble(),
    startLongitude: (json['StartLongitude'] as num)?.toDouble(),
    currentLattitude: (json['CurrentLattitude'] as num)?.toDouble(),
    currentLongitude: (json['CurrentLongitude'] as num)?.toDouble(),
    currentRouteStatus: (json['CurrentRouteStatus'] as List)
        ?.map((e) => e == null
            ? null
            : PlaceWithEtaResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gDirection: json['GDirection'] as String,
  );
}

Map<String, dynamic> _$BusTrackResponseDtoToJson(
        BusTrackResponseDto instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'BusId': instance.busId,
      'LastDestination': instance.lastDestination,
      'Route': instance.routeResponse,
      'CurrentLattitude': instance.currentLattitude,
      'CurrentLongitude': instance.currentLongitude,
      'StartLattitude': instance.startLattitude,
      'StartLongitude': instance.startLongitude,
      'GDirection': instance.gDirection,
      'CurrentRouteStatus': instance.currentRouteStatus,
    };
