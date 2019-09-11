// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_current_lat_lng.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCurrentLatLng _$UpdateCurrentLatLngFromJson(Map<String, dynamic> json) {
  return UpdateCurrentLatLng(
    busId: json['BusId'] as String,
    currentLocation: json['CurrentLocation'] == null
        ? null
        : LatLong.fromJson(json['CurrentLocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateCurrentLatLngToJson(
        UpdateCurrentLatLng instance) =>
    <String, dynamic>{
      'BusId': instance.busId,
      'CurrentLocation': instance.currentLocation,
    };
