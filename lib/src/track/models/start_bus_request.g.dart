// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_bus_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartBusRequest _$StartBusRequestFromJson(Map<String, dynamic> json) {
  return StartBusRequest(
    busId: json['BusId'] as String,
    routeId: json['RouteId'] as String,
    currentLattitude: json['CurrentLattitude'] as String,
    currentLongitude: json['CurrentLongitude'] as String,
    startLattitude: json['StartLattitude'] as String,
    startLongitude: json['StartLongitude'] as String,
  );
}

Map<String, dynamic> _$StartBusRequestToJson(StartBusRequest instance) =>
    <String, dynamic>{
      'BusId': instance.busId,
      'RouteId': instance.routeId,
      'CurrentLattitude': instance.currentLattitude,
      'CurrentLongitude': instance.currentLongitude,
      'StartLattitude': instance.startLattitude,
      'StartLongitude': instance.startLongitude,
    };
