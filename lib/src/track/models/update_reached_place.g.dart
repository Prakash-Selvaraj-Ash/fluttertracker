// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reached_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReachedPlace _$UpdateReachedPlaceFromJson(Map<String, dynamic> json) {
  return UpdateReachedPlace(
    busId: json['BusId'] as String,
    lastDestinationId: json['LastDestinationId'] as String,
    currentLocation: json['CurrentLocation'] == null
        ? null
        : LatLong.fromJson(json['CurrentLocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateReachedPlaceToJson(UpdateReachedPlace instance) =>
    <String, dynamic>{
      'BusId': instance.busId,
      'CurrentLocation': instance.currentLocation,
      'LastDestinationId': instance.lastDestinationId,
    };
