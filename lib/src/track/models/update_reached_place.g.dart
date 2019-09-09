// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reached_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReacedPlace _$UpdateReacedPlaceFromJson(Map<String, dynamic> json) {
  return UpdateReacedPlace(
    busId: json['BusId'] as String,
    lastDestinationId: json['LastDestinationId'] as String,
    currentLocation: json['CurrentLocation'] == null
        ? null
        : LatLong.fromJson(json['CurrentLocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateReacedPlaceToJson(UpdateReacedPlace instance) =>
    <String, dynamic>{
      'BusId': instance.busId,
      'CurrentLocation': instance.currentLocation,
      'LastDestinationId': instance.lastDestinationId,
    };
