// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_bus_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartBusResponse _$StartBusResponseFromJson(Map<String, dynamic> json) {
  return StartBusResponse(
    busId: json['BusId'] as String,
    id: json['Id'] as String,
    currentLattitude: json['CurrentLattitude'] as String,
    currentLongitude: json['CurrentLongitude'] as String,
    startLattitude: json['StartLattitude'] as String,
    startLongitude: json['StartLongitude'] as String,
    gDirection: json['GDirection'] as String,
    lastDestination: json['LastDestination'] == null
        ? null
        : PlaceResponse.fromJson(
            json['LastDestination'] as Map<String, dynamic>),
    route: json['Route'] == null
        ? null
        : RouteResponse.fromJson(json['Route'] as Map<String, dynamic>),
    currentRouteStatus: json['CurrentRouteStatus'] == null
        ? null
        : PlaceResponse.fromJson(
            json['CurrentRouteStatus'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StartBusResponseToJson(StartBusResponse instance) =>
    <String, dynamic>{
      'LastDestination': instance.lastDestination,
      'Route': instance.route,
      'CurrentRouteStatus': instance.currentRouteStatus,
      'BusId': instance.busId,
      'Id': instance.id,
      'GDirection': instance.gDirection,
      'CurrentLattitude': instance.currentLattitude,
      'CurrentLongitude': instance.currentLongitude,
      'StartLattitude': instance.startLattitude,
      'StartLongitude': instance.startLongitude,
    };
